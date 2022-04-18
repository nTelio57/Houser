using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class RoomFilterRepository : Repository<RoomFilter>
    {
        protected override DbSet<RoomFilter> Entities { get; }
        public RoomFilterRepository(DatabaseContext context) : base(context)
        {
            Entities = context.RoomFilters;
        }
    }
}
