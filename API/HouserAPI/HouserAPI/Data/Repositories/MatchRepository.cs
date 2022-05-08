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
            return queryable.Include(x => x.UserOfferer).Include(x => x.RoomOfferer);
        }

        public virtual async Task<IEnumerable<Match>> GetAllByUser(string userId)
        {
            return await IncludeDependencies(Entities)
                .Include(x => x.UserOfferer).ThenInclude(x => x.Images.Where(y => y.RoomId == null))
                .Include(x => x.RoomOfferer).ThenInclude(x => x.Images.Where(y => y.RoomId == null))
                .Include(x => x.Room).ThenInclude(x => x.Images)
                .Where(x => x.UserOffererId == userId || x.RoomOffererId == userId).ToListAsync();
        }

        public async Task<IEnumerable<Match>> GetByMatchId(int id)
        {
            return await IncludeDependencies(Entities).Where(x => x.RoomId == id).ToListAsync();
        }
    }
}
