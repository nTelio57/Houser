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
    }
}
