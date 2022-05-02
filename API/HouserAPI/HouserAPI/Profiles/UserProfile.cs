using System.Linq;
using AutoMapper;
using HouserAPI.DTOs.User;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class UserProfile : Profile
    {
        public UserProfile()
        {
            CreateMap<User, UserReadDto>()
                .ForMember(dst => dst.Images, opt => opt.MapFrom(map => map.Images.Where(x => x.RoomId == null)));
            CreateMap<UserCreateDto, User>();
            CreateMap<UserUpdateDto, User>();
            CreateMap<User, UserUpdateDto>();
        }
    }
}
