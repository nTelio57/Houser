using AutoMapper;
using HouserAPI.DTOs.Match;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class MatchProfile : Profile
    {
        public MatchProfile()
        {
            CreateMap<Match, MatchReadDto>();
            CreateMap<MatchCreateDto, Match>();
        }
    }
}
