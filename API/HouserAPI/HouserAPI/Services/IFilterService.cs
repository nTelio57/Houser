using System.Threading.Tasks;
using HouserAPI.DTOs.Filter;

namespace HouserAPI.Services
{
    public interface IFilterService
    {
        Task<FilterReadDto> GetByUserId(string userId);
        Task<FilterReadDto> Create(FilterCreateDto filterCreateDto, string userId);
    }
}
