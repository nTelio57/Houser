using System;
using System.Collections.Generic;
using HouserAPI.Auth;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Data.Seed
{
    public static class UserSeed
    {
        public static string IdBasic = "6e58169a-cc76-45b9-8d20-ef40fda183a3";
        public static string IdBasic2 = "9a8865c2-9297-4675-a038-efbf192e75f3";
        public static string IdAdmin = "570457bc-51a6-47d7-90a1-cc3cd1598563";

        public static void Seed(UserManager<User> userManager)
        {
            var admin = new User
            {
                Id = IdAdmin,
                Email = "admin@gmail.com",
                Name = "AdminName",
                Surname = "AdminSurname",
                BirthDate = new DateTime(1999, 11, 08),
                UserName = "Admin",
                City = "Kaunas",
                Salt = "zoOCL2CFBCqEtTK5Ua197SwyVv2rckZoJEe+Ko8bUCU=",
                Elo = 500,
                IsVisible = true
            };

            var basic = new User
            {
                Id = IdBasic,
                Email = "basic@gmail.com",
                Name = "BasicName",
                Surname = "BasicSurname",
                BirthDate = new DateTime(1987, 02, 25),
                UserName = "Basic",
                City = "Vilnius",
                Salt = "kFcWCtYosDUdeiK0Gf+WcY0LcxdvcH3UtQQrvwf9fh8=",
                Elo = 500,
                IsVisible = true
            };

            var basic2 = new User
            {
                Id = IdBasic2,
                Email = "basic2@gmail.com",
                Name = "Basic2Name",
                Surname = "Basic2Surname",
                BirthDate = new DateTime(2000, 07, 16),
                UserName = "basic2",
                City = "Klaipeda",
                Salt = "VoW7Vl2PL4g9erbq1ncE6cpQbVmHMR3dDhLGx9EYhbM=",
                Elo = 500,
                IsVisible = true
            };

            CreateUser(userManager, admin, "test1234", UserRoles.All);
            CreateUser(userManager, basic, "test1234", new[] { UserRoles.Basic });
            CreateUser(userManager, basic2, "test1234", new[] { UserRoles.Basic });
        }

        private static void CreateUser(UserManager<User> userManager, User user, string password, IEnumerable<string> roles)
        {
            var isExisting = userManager.FindByEmailAsync(user.Email).Result;
            if (isExisting == null)
            {
                var result = userManager.CreateAsync(user, password + user.Salt).Result;
                if (result.Succeeded)
                {
                    userManager.AddToRolesAsync(user, roles).Wait();
                }
            }
        }
    }
}
