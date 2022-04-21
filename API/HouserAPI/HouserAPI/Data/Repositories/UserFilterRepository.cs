using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class UserFilterRepository : Repository<UserFilter>
    {
        protected override DbSet<UserFilter> Entities { get; }
        public UserFilterRepository(DatabaseContext context) : base(context)
        {
            Entities = context.UserFilters;
        }

        public async Task<UserFilter> GetByUserId(string userId)
        {
            return await IncludeDependencies(Entities).FirstOrDefaultAsync(x => x.UserId == userId);
        }
    }
}
