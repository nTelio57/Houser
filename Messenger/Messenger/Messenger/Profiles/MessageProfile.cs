using AutoMapper;
using Messenger.DTOs.Message;
using Messenger.Models;

namespace Messenger.Profiles
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
