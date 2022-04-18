using System.Threading.Tasks;
using HouserAPI.DTOs.Filter;

namespace HouserAPI.Services
{
    public interface IFilterService
    {
        Task<FilterReadDto> Create(FilterCreateDto filterCreateDto, string userId);
    }
}
