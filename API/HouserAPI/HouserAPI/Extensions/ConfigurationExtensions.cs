using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HouserAPI.Auth;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace HouserAPI.Extensions
{
    public static class ConfigurationExtensions
    {
        public static IServiceCollection AddAuthorizationDependencies(this IServiceCollection services, IConfiguration configuration)
        {
            return services
                .AddTransient<ITokenManager, TokenManager>();
        }

        public static AuthenticationBuilder AddJwtAuthentication(this IServiceCollection services, IConfiguration configuration)
        {
            return services.AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
                })
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters.ValidAudience = configuration["JwtSettings:ValidAudience"];
                    options.TokenValidationParameters.ValidIssuer = configuration["JwtSettings:ValidIssuer"];
                    options.TokenValidationParameters.IssuerSigningKey =
                        new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JwtSettings:Secret"]));
                });
        }
    }
}
