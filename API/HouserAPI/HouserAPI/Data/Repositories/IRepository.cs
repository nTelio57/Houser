using System.Collections.Generic;
using System.Threading.Tasks;

namespace HouserAPI.Data.Repositories
{
    public interface IRepository<TEntity>
    {
        Task<bool> SaveChanges();
        Task Create(TEntity entity);
        Task<TEntity> GetById(int id);
        Task<IEnumerable<TEntity>> GetAll();
        Task Update(TEntity entity);
        Task Delete(TEntity entity);
    }
}
