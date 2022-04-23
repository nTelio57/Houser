using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class MatchRepository : Repository<Match>
    {
        protected override DbSet<Match> Entities { get; }
        public MatchRepository(DatabaseContext context) : base(context)
        {
            Entities = context.Matches;
        }

        public async Task<IEnumerable<Match>> GetAllByUser(string userId)
        {
            return await IncludeDependencies(Entities).Where(x => x.FirstUserId == userId || x.SecondUserId == userId).ToListAsync();
        }
    }
}
