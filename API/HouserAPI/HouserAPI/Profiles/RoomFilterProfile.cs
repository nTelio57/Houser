using AutoMapper;
using HouserAPI.DTOs.Filter;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class RoomFilterProfile : Profile
    {
        public RoomFilterProfile()
        {
            CreateMap<RoomFilter, RoomFilterReadDto>();
            CreateMap<RoomFilterCreateDto, RoomFilter>();
        }
    }
}
