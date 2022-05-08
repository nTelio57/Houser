using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class MessageRepository : Repository<Message>
    {
        protected override DbSet<Message> Entities { get; }
        public MessageRepository(DatabaseContext context) : base(context)
        {
            Entities = context.Messages;
        }

        public virtual async Task<IEnumerable<Message>> GetAllByMatchId(int matchId)
        {
            return await IncludeDependencies(Entities).Where(x => x.MatchId == matchId).ToListAsync();
        }
    }
}
