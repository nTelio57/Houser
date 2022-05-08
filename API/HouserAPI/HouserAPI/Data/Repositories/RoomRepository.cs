using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class RoomRepository : Repository<Room>
    {
        protected override DbSet<Room> Entities { get; }
        public RoomRepository(DatabaseContext context) : base(context)
        {
            Entities = context.Rooms;
        }

        protected override IQueryable<Room> IncludeDependencies(IQueryable<Room> queryable)
        {
            return queryable.Include(x => x.User).ThenInclude(x => x.Images).Include(x => x.Images);
        }

        public virtual async Task<IEnumerable<Room>> GetAllByUser(string userId)
        {
            return await IncludeDependencies(Entities).Where(x => x.UserId == userId).ToListAsync();
        }
    }
}
