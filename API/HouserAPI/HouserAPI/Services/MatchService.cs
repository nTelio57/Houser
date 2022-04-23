using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Swipe;
using HouserAPI.Enums;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Services
{
    public class MatchService : IMatchService
    {
        private readonly IMapper _mapper;
        private readonly SwipeRepository _swipeRepository;
        private readonly UserManager<User> _userManager;

        public MatchService(IMapper mapper, IRepository<Swipe> swipeRepository, UserManager<User> userManager)
        {
            _mapper = mapper;
            _swipeRepository = swipeRepository as SwipeRepository;
            _userManager = userManager;
        }

        public async Task<SwipeReadDto> Swipe(SwipeCreateDto swipeCreateDto)
        {
            if (swipeCreateDto.SwipeType == SwipeType.Dislike)
                return await Dislike(swipeCreateDto);
            return await Like(swipeCreateDto);
        }

        private async Task<SwipeReadDto> Like(SwipeCreateDto swipeCreateDto)
        {
            //paziureti ar jau like swipe kai sitas useris yra kaip targetas ir targetas yra kaip 
            //jeigu nera - palikti duombazei sita swipe
            //jeigu yra istrinti is db ta sena swipe ir sukurti matcha
            //jeigu yra dislike db nedaryti nieko
            //duoti target useriui elo

            var swipe = _mapper.Map<Swipe>(swipeCreateDto);
            var otherSide =
                await _swipeRepository.GetByBothSidesId(swipeCreateDto.UserTargetId, swipeCreateDto.SwiperId);
            var swipeReadDto = _mapper.Map<SwipeReadDto>(swipe);
            swipeReadDto.SwipeResult = SwipeResult.Swiped;

            if (otherSide == null)
            {
                await _swipeRepository.Create(swipe);
            }
            else
            {
                if (otherSide.SwipeType == SwipeType.Like)
                {
                    await _swipeRepository.Delete(otherSide);
                    //sukurti matcha----------------
                    swipeReadDto.SwipeResult = SwipeResult.Matched;
                }
            }
            await UpdateElo(swipeCreateDto);

            return swipeReadDto;
        }

        private async Task<SwipeReadDto> Dislike(SwipeCreateDto swipeCreateDto)
        {
            var swipe = _mapper.Map<Swipe>(swipeCreateDto);
            await _swipeRepository.Create(swipe);
            await _swipeRepository.SaveChanges();
            await UpdateElo(swipeCreateDto);

            var swipeReadDto = _mapper.Map<SwipeReadDto>(swipe);
            swipeReadDto.SwipeResult = SwipeResult.Swiped;
            return swipeReadDto;
        }

        private async Task UpdateElo(SwipeCreateDto swipeCreateDto, int K = 32)
        {
            int swipeType = (int)swipeCreateDto.SwipeType;

            var swiperUser = await _userManager.FindByIdAsync(swipeCreateDto.SwiperId);
            var targetUser = await _userManager.FindByIdAsync(swipeCreateDto.UserTargetId);

            double expectedTarget = 1 / (1 + Math.Pow(10, ((double)targetUser.Elo - swiperUser.Elo) / 400));
            double eloResult = K * (swipeType - expectedTarget);

            targetUser.Elo = targetUser.Elo + Convert.ToInt32(eloResult);
            await _userManager.UpdateAsync(targetUser);
        }
    }
}
