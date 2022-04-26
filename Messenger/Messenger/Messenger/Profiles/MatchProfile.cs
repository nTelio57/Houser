using AutoMapper;
using Messenger.DTOs.Match;
using Messenger.Models;

namespace Messenger.Profiles
{
    public class MatchProfile : Profile
    {
        public MatchProfile()
        {
            CreateMap<Match, MatchReadDto>();
        }
    }
}
