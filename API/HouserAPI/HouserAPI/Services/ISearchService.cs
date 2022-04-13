using System.Threading.Tasks;
using HouserAPI.DTOs.Offer;

namespace HouserAPI.Services
{
    public interface ISearchService
    {
        Task<OfferReadDto> GetRecommendationByFilter();
    }
}
