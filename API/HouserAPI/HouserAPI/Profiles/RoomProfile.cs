using System.Linq;
using AutoMapper;
using HouserAPI.DTOs.Room;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class RoomProfile : Profile
    {
        public RoomProfile()
        {
            CreateMap<Room, RoomReadDto>();
            CreateMap<RoomCreateDto, Room>();
            CreateMap<RoomUpdateDto, Room>();
            CreateMap<Room, RoomUpdateDto>();
        }
    }
}
