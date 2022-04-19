using HouserAPI.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data
{
    public class DatabaseContext : IdentityDbContext<User>
    {
        public DbSet<Image> Images{ get; set; }
        public DbSet<Room> Rooms{ get; set; }
        public DbSet<RoomFilter> RoomFilters { get; set; }
        public DbSet<UserFilter> UserFilters { get; set; }
        public DatabaseContext(DbContextOptions<DatabaseContext> opt) : base(opt)
        {
            
        }
    }
}
