using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Offer;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public class RecommendationService : IRecommendationService
    {
        private readonly OfferRepository _offerRepository;
        private readonly IMapper _mapper;
        private readonly ApiClient _recommendationApiClient;

        public RecommendationService(IRepository<Offer> repository, IMapper mapper, ApiClient apiClient)
        {
            _offerRepository = repository as OfferRepository;
            _mapper = mapper;
            _recommendationApiClient = apiClient;
        }

        public async Task<IEnumerable<OfferReadDto>> GetRoomRecommendationByFilter(int count, int offset, RoomFilter roomFilter)
        {
            var recommendations = await _recommendationApiClient.Post<IEnumerable<OfferRecommendationResponse>>("/room_recommendation", roomFilter);
            var offers = await _offerRepository.GetAllWithId(recommendations.Select(x => x.Id));

            return _mapper.Map<IEnumerable<OfferReadDto>>(offers);
        }

        
    }
}
