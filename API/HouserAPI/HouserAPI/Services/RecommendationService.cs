using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Room;
using HouserAPI.DTOs.User;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace HouserAPI.Services
{
    public class RecommendationService : IRecommendationService
    {
        private readonly RoomRepository _roomRepository;
        private readonly IMapper _mapper;
        private readonly ApiClient _recommendationApiClient;
        private readonly UserManager<User> _userManager;

        public RecommendationService(IRepository<Room> repository, IMapper mapper, ApiClient apiClient, UserManager<User> userManager)
        {
            _roomRepository = repository as RoomRepository;
            _mapper = mapper;
            _recommendationApiClient = apiClient;
            _userManager = userManager;
        }

        public async Task<IEnumerable<RoomReadDto>> GetRoomRecommendationByFilter(int count, int offset, RoomFilter roomFilter, string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            roomFilter.Elo = user.Elo;

            var roomList = new List<Room>();
            var recommendationPredictions = await _recommendationApiClient.Post<IEnumerable<RoomRecommendationResponse>>("/room", roomFilter);
            var roomRecommendationResponses = recommendationPredictions.ToList();
            if(offset >= roomRecommendationResponses.Count)
                return _mapper.Map<IEnumerable<RoomReadDto>>(roomList);

            for (int i = 0; i < Math.Min(count, (roomRecommendationResponses.Count - offset)); i++)
            {
                roomList.Add(await _roomRepository.GetById(roomRecommendationResponses[i + offset].Id));
            }

            return _mapper.Map<IEnumerable<RoomReadDto>>(roomList);
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
                userList.Add(await _userManager.Users.Include(x => x.Images.Where(y => y.RoomId == null)).FirstOrDefaultAsync(x => x.Id == userRecommendationResponses[i + offset].Id));
            }
            return _mapper.Map<IEnumerable<UserReadDto>>(userList);
        }
    }
}
