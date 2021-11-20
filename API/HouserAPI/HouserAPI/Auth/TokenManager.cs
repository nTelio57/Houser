using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace HouserAPI.Auth
{
    public interface ITokenManager
    {
        Task<string> CreateAccessTokenAsync(User user);
    }
    public class TokenManager : ITokenManager
    {
        private readonly UserManager<User> _userManager;
        private readonly SymmetricSecurityKey _authSigningKey;
        private readonly string _issuer;
        private readonly string _audience;

        public TokenManager(UserManager<User> userManager, IConfiguration configuration)
        {
            _userManager = userManager;
            _authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JwtSettings:Secret"]));
            _issuer = configuration["JwtSettings:ValidIssuer"];
            _audience = configuration["JwtSettings:ValidAudience"];
        }

        public async Task<string> CreateAccessTokenAsync(User user)
        {
            var userRoles = await _userManager.GetRolesAsync(user);
            var authClaims = new List<Claim>
            {
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(CustomClaims.UserId, user.Id),
            };
            authClaims.AddRange(userRoles.Select(userRole => new Claim(ClaimTypes.Role, userRole)));

            var accessSecurityToken = new JwtSecurityToken(
                issuer: _issuer,
                audience: _audience,
                expires: DateTime.UtcNow.AddMonths(1),
                claims: authClaims,
                signingCredentials: new SigningCredentials(_authSigningKey, SecurityAlgorithms.HmacSha256)
            );

            return new JwtSecurityTokenHandler().WriteToken(accessSecurityToken);
        }
    }
}
