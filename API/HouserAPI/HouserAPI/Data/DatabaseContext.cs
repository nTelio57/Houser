using HouserAPI.Enums;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data
{
    public class DatabaseContext : IdentityDbContext<User>
    {
        public DbSet<Image> Images{ get; set; }
        public DbSet<Room> Rooms{ get; set; }
        public DbSet<Filter> Filters { get; set; }
        public DbSet<UserFilter> UserFilters { get; set; }
        public DbSet<RoomFilter> RoomFilters { get; set; }
        public DbSet<Swipe> Swipes { get; set; }
        public DbSet<Match> Matches { get; set; }
        public DbSet<Message> Messages{ get; set; }
        public DatabaseContext(DbContextOptions<DatabaseContext> opt) : base(opt)
        {
            
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<Filter>()
                .HasDiscriminator(x => x.FilterType)
                .HasValue<Filter>(FilterType.None)
                .HasValue<RoomFilter>(FilterType.Room)
                .HasValue<UserFilter>(FilterType.User);

            base.OnModelCreating(builder);
        }
    }
}
