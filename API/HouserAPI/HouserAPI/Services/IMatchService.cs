using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Match;
using HouserAPI.DTOs.Swipe;

namespace HouserAPI.Services
{
    public interface IMatchService
    {
        Task<IEnumerable<MatchReadDto>> GetAllByUser(string id);
        Task<MatchReadDto> GetById(int id);
        Task<bool> Delete(int id);
        Task<SwipeReadDto> Swipe(SwipeCreateDto swipeCreateDto);
        Task<bool> DeleteRoomSwipesAndMatches(int id);
    }
}
