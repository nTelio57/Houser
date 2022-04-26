using AutoMapper;
using HouserAPI.DTOs.Message;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class MessageProfile : Profile
    {
        public MessageProfile()
        {
            CreateMap<Message, MessageReadDto>();
            CreateMap<MessageCreateDto, Message>();
        }
    }
}
