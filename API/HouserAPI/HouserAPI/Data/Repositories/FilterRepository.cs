using System.Linq;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class FilterRepository : Repository<Filter>
    {
        protected override DbSet<Filter> Entities { get; }
        public FilterRepository(DatabaseContext context) : base(context)
        {
            Entities = context.Filters;
        }

        public virtual async Task<Filter> GetByUserId(string userId)
        {
            return await IncludeDependencies(Entities).FirstOrDefaultAsync(x => x.UserId == userId);
        }
    }
}
