﻿using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public class SwipeRepository : Repository<Swipe>
    {
        protected override DbSet<Swipe> Entities { get; }
        public SwipeRepository(DatabaseContext context) : base(context)
        {
            Entities = context.Swipes;
        }

        public async Task<Swipe> GetByBothSidesId(string swiperId, string targetId)
        {
            return await IncludeDependencies(Entities).FirstOrDefaultAsync(x => x.SwiperId == swiperId && x.UserTargetId == targetId);
        }
    }
}
