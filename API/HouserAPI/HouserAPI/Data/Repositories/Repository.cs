using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HouserAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Data.Repositories
{
    public abstract class Repository<TEntity> : IRepository<TEntity> where TEntity : Entity
    {
        protected readonly DatabaseContext Context;
        protected abstract DbSet<TEntity> Entities { get; }
        protected Repository(DatabaseContext context)
        {
            Context = context;
        }
        public virtual async Task<bool> SaveChanges()
        {
            return await Context.SaveChangesAsync() >= 0;
        }

        protected virtual IQueryable<TEntity> IncludeDependencies(IQueryable<TEntity> queryable)
        {
            return queryable;
        }

        public virtual async Task Create(TEntity entity)
        {
            if (entity == null)
                throw new ArgumentNullException(nameof(entity));
            await Entities.AddAsync(entity);
        }

        public virtual async Task<TEntity> GetById(int id)
        {
            return await IncludeDependencies(Entities).FirstOrDefaultAsync(x => x.Id == id);
        }

        public virtual async Task<IEnumerable<TEntity>> GetAll()
        {
            return await IncludeDependencies(Entities).ToListAsync();
        }

        public virtual async Task Update(TEntity entity)
        {

        }

        public virtual async Task Delete(TEntity entity)
        {
            if (entity == null)
                throw new ArgumentNullException(nameof(entity));
            Entities.Remove(entity);
        }
    }
}
