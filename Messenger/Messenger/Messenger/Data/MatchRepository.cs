using Messenger.Models;
using Microsoft.EntityFrameworkCore;

namespace Messenger.Data
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
