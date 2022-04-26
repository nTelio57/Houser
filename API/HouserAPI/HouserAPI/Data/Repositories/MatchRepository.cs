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

        protected override IQueryable<Match> IncludeDependencies(IQueryable<Match> queryable)
        {
            return queryable.Include(x => x.FirstUser).Include(x => x.SecondUser);
        }

        public async Task<IEnumerable<Match>> GetAllByUser(string userId)
        {
            return await IncludeDependencies(Entities)
                .Include(x => x.FirstUser).ThenInclude(x => x.Images.Where(y => y.RoomId == null))
                .Include(x => x.SecondUser).ThenInclude(x => x.Images.Where(y => y.RoomId == null))
                .Include(x => x.Room).ThenInclude(x => x.Images)
                .Where(x => x.FirstUserId == userId || x.SecondUserId == userId).ToListAsync();
        }
    }
}
