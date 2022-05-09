using System;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Auth;
using HouserAPI.DTOs.User;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly IMapper _mapper;

        public UserController(UserManager<User> userManager, IMapper mapper)
        {
            _userManager = userManager;
            _mapper = mapper;
        }

        [HttpGet("{id}", Name = "GetUserById")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetUserById(string id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var user = await _userManager.FindByIdAsync(id);
            if (user is null)
                return NotFound();

            return Ok(_mapper.Map<UserReadDto>(user));
        }

        [HttpPut("{id}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> UpdateUser(string id, UserUpdateDto userUpdateDto)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var user = await _userManager.FindByIdAsync(id);
            if (user == null)
                return NotFound();

            _mapper.Map(userUpdateDto, user);
            await _userManager.UpdateAsync(user);
            return NoContent();
        }

        [HttpPut("visibility/{id}/{visibility}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> UpdateVisibility(string id, int visibility)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var user = await _userManager.FindByIdAsync(id);
            if (user == null)
                return NotFound();

            user.IsVisible = Convert.ToBoolean(visibility);
            await _userManager.UpdateAsync(user);
            return NoContent();
        }
    }
}
