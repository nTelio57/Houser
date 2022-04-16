using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Offer;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Services
{
    public class RecommendationService : IRecommendationService
    {
        private readonly OfferRepository _offerRepository;
        private readonly IMapper _mapper;
        private readonly ApiClient _recommendationApiClient;
        private readonly UserManager<User> _userManager;

        public RecommendationService(IRepository<Offer> repository, IMapper mapper, ApiClient apiClient, UserManager<User> userManager)
        {
            _offerRepository = repository as OfferRepository;
            _mapper = mapper;
            _recommendationApiClient = apiClient;
            _userManager = userManager;
        }

        public async Task<IEnumerable<OfferReadDto>> GetRoomRecommendationByFilter(int count, int offset, RoomFilter roomFilter, string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            roomFilter.Elo = user.Elo;

            var recommendations = await _recommendationApiClient.Post<IEnumerable<OfferRecommendationResponse>>("/room", roomFilter);
            var offers = await _offerRepository.GetAllWithId(recommendations.Select(x => x.Id));

            return _mapper.Map<IEnumerable<OfferReadDto>>(offers);
        }

        
    }
}
