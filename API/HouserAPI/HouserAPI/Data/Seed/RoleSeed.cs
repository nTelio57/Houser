using HouserAPI.Auth;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Data.Seed
{
    public static class RoleSeed
    {
        public static void Seed(RoleManager<IdentityRole> roleManager)
        {
            foreach (var role in UserRoles.All)
            {
                var roleExist = roleManager.RoleExistsAsync(role).Result;
                if (!roleExist)
                {
                    roleManager.CreateAsync(new IdentityRole(role)).Wait();
                }
            }
        }
    }
}
