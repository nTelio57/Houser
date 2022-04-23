using AutoMapper;
using HouserAPI.DTOs.Swipe;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class SwipeProfile : Profile
    {
        public SwipeProfile()
        {
            CreateMap<Swipe, SwipeReadDto>();
            CreateMap<SwipeCreateDto, Swipe>();
        }
    }
}
