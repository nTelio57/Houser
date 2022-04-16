using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Offer;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public interface IRecommendationService
    {
        Task<IEnumerable<OfferReadDto>> GetRoomRecommendationByFilter(int count, int offset, RoomFilter roomFilter);
    }
}
