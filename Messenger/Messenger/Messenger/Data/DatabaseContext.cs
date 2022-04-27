using Messenger.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Messenger.Data
{
    public class DatabaseContext : IdentityDbContext<User>
    {
        public DbSet<Match> Matches { get; set; }
        public DbSet<Message> Messages{ get; set; }
        public DatabaseContext(DbContextOptions<DatabaseContext> opt) : base(opt)
        {
            
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Match>().ToTable(nameof(Matches), t => t.ExcludeFromMigrations());
            modelBuilder.Entity<User>().ToTable("AspNetUsers", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<Message>().ToTable("Messages", t => t.ExcludeFromMigrations());

            modelBuilder.Entity<IdentityRole>().ToTable("AspNetRoles", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<IdentityUserClaim<string>>().ToTable("AspNetUserClaims", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<IdentityUserLogin<string>>().ToTable("AspNetUserLogins", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<IdentityUserToken<string>>().ToTable("AspNetUserTokens", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<IdentityRoleClaim<string>>().ToTable("AspNetRoleClaims", t => t.ExcludeFromMigrations());
            modelBuilder.Entity<IdentityUserRole<string>>().ToTable("AspNetUserRoles", t => t.ExcludeFromMigrations());

            base.OnModelCreating(modelBuilder);
        }
    }
}
