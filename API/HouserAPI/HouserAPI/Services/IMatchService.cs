using System.Threading.Tasks;
using HouserAPI.DTOs.Swipe;

namespace HouserAPI.Services
{
    public interface IMatchService
    {
        Task<SwipeReadDto> Swipe(SwipeCreateDto swipeCreateDto);
    }
}
