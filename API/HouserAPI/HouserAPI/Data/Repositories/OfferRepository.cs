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

        protected override IQueryable<Offer> IncludeDependencies(IQueryable<Offer> queryable)
        {
            return queryable.Include(x => x.Images);
        }

        public async Task<IEnumerable<Offer>> GetAllByUser(string userId)
        {
            return await IncludeDependencies(Entities).Where(x => x.UserId == userId).ToListAsync();
        }

        //Temporary for debug reasons
        public async Task<Offer> GetFirstRandom()
        {
            return await IncludeDependencies(Entities).FirstOrDefaultAsync();
        }
    }
}
