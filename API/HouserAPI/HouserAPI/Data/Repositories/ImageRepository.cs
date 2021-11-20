using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class ImageRepository : Repository<Image>
    {
        protected override DbSet<Image> Entities { get; }
        public ImageRepository(DatabaseContext context) : base(context)
        {
            Entities = context.Images;
        }

        public async Task<IEnumerable<Image>> GetAllByUser(string userId)
        {
            return await IncludeDependencies(Entities).Where(x => x.UserId == userId).ToListAsync();
        }
    }
}
