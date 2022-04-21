using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Data.Seed
{
    public class SeedData
    {
        private readonly DatabaseContext _context;
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        public SeedData(DatabaseContext context, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            _context = context;
            _userManager = userManager;
            _roleManager = roleManager;
        }

        public void Seed()
        {
            _context.Database.EnsureCreated();

            RoleSeed.Seed(_roleManager);

            _context.SaveChanges();
        }

        public void SeedDevelopment()
        {
            _context.Database.EnsureCreated();

            RoleSeed.Seed(_roleManager);
            UserSeed.Seed(_userManager);
            ImageSeed.Seed(_context);
            RoomSeed.Seed(_context);

            _context.SaveChanges();
        }
    }
}
