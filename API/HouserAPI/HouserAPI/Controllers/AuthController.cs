using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Auth;
using HouserAPI.DTOs.User;
using HouserAPI.Models;
using HouserAPI.Utilities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly ITokenManager _tokenManager;
        private readonly IPasswordValidator<User> _passwordValidator;
        private readonly IMapper _mapper;

        public AuthController(UserManager<User> userManager, ITokenManager tokenManager, IPasswordValidator<User> passwordValidator, IMapper mapper)
        {
            _userManager = userManager;
            _tokenManager = tokenManager;
            _passwordValidator = passwordValidator;
            _mapper = mapper;
        }

        [HttpPost("register")]
        [AllowAnonymous]
        public async Task<IActionResult> Register(UserCreateDto authRequest)
        {
            authRequest.Email = authRequest.Email.Trim();
            var user = await _userManager.FindByEmailAsync(authRequest.Email);
            if (user != null)
            {
                return BadRequest(new AuthResult
                {
                    Success = false,
                    Errors = new[] { "User with this email address already exists." }
                });
            }
            var result = await _passwordValidator.ValidateAsync(_userManager, null, authRequest.Password);
            if (!result.Succeeded)
                return BadRequest(new AuthResult
                {
                    Success = false,
                    Errors = result.Errors.Select(x => x.Description)
                });

            var salt = Cryptography.GenerateSalt();
            var newUser = new User
            {
                UserName = authRequest.Email,
                Email = authRequest.Email,
                Salt = salt,
                Elo = 500
            };

            var createdUser = await _userManager.CreateAsync(newUser, authRequest.Password + salt);
            if (!createdUser.Succeeded)
                return BadRequest(new AuthResult
                {
                    Success = false,
                    Errors = new[] { "Could not create a user." }
                });

            await _userManager.AddToRoleAsync(newUser, UserRoles.Basic);
            var accessToken = await _tokenManager.CreateAccessTokenAsync(newUser);
            var roles = await _userManager.GetRolesAsync(newUser);

            return CreatedAtAction(nameof(Register), new AuthResult
            {
                Success = true,
                Token = accessToken,
                User = _mapper.Map<UserReadDto>(newUser),
                Roles = roles
            });
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login(AuthRequest authRequest)
        {
            authRequest.Email = authRequest.Email.Trim();
            var user = await _userManager.FindByEmailAsync(authRequest.Email);
            if (user == null)
            {
                return BadRequest(new AuthResult
                {
                    Success = false,
                    Errors = new[] { "Wrong credentials." }
                });
            }

            var isPasswordValid = await _userManager.CheckPasswordAsync(user, authRequest.Password + user.Salt);
            if (!isPasswordValid)
            {
                return BadRequest(new AuthResult 
                {
                    Success = false,
                    Errors = new[] { "Wrong credentials." }
                });
            }

            var roles = await _userManager.GetRolesAsync(user);

            var accessToken = await _tokenManager.CreateAccessTokenAsync(user);
            return Ok(new AuthResult
            {
                Success = true,
                Token = accessToken,
                User = _mapper.Map<UserReadDto>(user),
                Roles = roles
            });
        }
    }
}
