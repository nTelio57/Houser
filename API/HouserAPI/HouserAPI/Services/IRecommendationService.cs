using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Room;
using HouserAPI.DTOs.User;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public interface IRecommendationService
    {
        Task<IEnumerable<RoomReadDto>> GetRoomRecommendationByFilter(int count, int offset, RoomFilter roomFilter, string userId);
        Task<IEnumerable<UserReadDto>> GetUserRecommendationByFilter(int count, int offset, UserFilter roomFilter, string userId);
    }
}
