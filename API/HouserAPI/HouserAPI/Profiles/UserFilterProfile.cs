using AutoMapper;
using HouserAPI.DTOs.Filter;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class UserFilterProfile : Profile
    {
        public UserFilterProfile()
        {
            CreateMap<UserFilter, UserFilterReadDto>();
            CreateMap<UserFilterCreateDto, UserFilter>();
        }
    }
}
