using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class OfferRepository : Repository<Offer>
    {
        protected override DbSet<Offer> Entities { get; }
        public OfferRepository(DatabaseContext context) : base(context)
        {
            Entities = context.Offers;
        }

        public async Task<IEnumerable<Offer>> GetAllByUser(string userId)
        {
            return await IncludeDependencies(Entities).Where(x => x.UserId == userId).ToListAsync();
        }
    }
}
