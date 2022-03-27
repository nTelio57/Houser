using HouserAPI.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data
{
    public class DatabaseContext : IdentityDbContext<User>
    {
        public DbSet<Image> Images{ get; set; }
        public DbSet<Offer> Offers{ get; set; }
        public DatabaseContext(DbContextOptions<DatabaseContext> opt) : base(opt)
        {
            
        }
    }
}
