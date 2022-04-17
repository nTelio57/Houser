using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Offer;
using HouserAPI.DTOs.User;
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

            var offerList = new List<Offer>();
            var recommendationPredictions = await _recommendationApiClient.Post<IEnumerable<OfferRecommendationResponse>>("/room", roomFilter);
            var offerRecommendationResponses = recommendationPredictions.ToList();
            if(offset >= offerRecommendationResponses.Count)
                return _mapper.Map<IEnumerable<OfferReadDto>>(offerList);

            for (int i = 0; i < Math.Min(count, (offerRecommendationResponses.Count - offset)); i++)
            {
                offerList.Add(await _offerRepository.GetById(offerRecommendationResponses[i + offset].Id));
            }

            return _mapper.Map<IEnumerable<OfferReadDto>>(offerList);
        }

        public async Task<IEnumerable<UserReadDto>> GetUserRecommendationByFilter(int count, int offset, UserFilter userFilter, string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            userFilter.Elo = user.Elo;

            var userList = new List<User>();
            var recommendationPredictions = await _recommendationApiClient.Post<IEnumerable<UserRecommendationResponse>>("/user", userFilter);
            var userRecommendationResponses = recommendationPredictions.ToList();
            if (offset >= userRecommendationResponses.Count)
                return _mapper.Map<IEnumerable<UserReadDto>>(userList);

            for (int i = 0; i < Math.Min(count, (userRecommendationResponses.Count - offset)); i++)
            {
                userList.Add(await _userManager.FindByIdAsync(userRecommendationResponses[i + offset].Id));
            }

            return _mapper.Map<IEnumerable<UserReadDto>>(userList);
        }
    }
}
