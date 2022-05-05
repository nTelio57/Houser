using System;
using System.Threading.Tasks;
using AutoMapper;
using Messenger.Data;
using Messenger.DTOs.Message;
using Messenger.Models;

namespace Messenger.Services
{
    public class MessageService : IMessageService
    {
        private readonly IMapper _mapper;
        private readonly IRepository<Match> _matchRepository;
        private readonly MessageRepository _messageRepository;

        public MessageService(IMapper mapper, IRepository<Message> messageRepository, IRepository<Match> matchRepository)
        {
            _mapper = mapper;
            _matchRepository = matchRepository;
            _messageRepository = messageRepository as MessageRepository;
        }

        public async Task<MessageReadDto> Create(MessageCreateDto messageCreateDto)
        {
            if (messageCreateDto == null)
                throw new ArgumentNullException(nameof(messageCreateDto));

            var messageModel = _mapper.Map<Message>(messageCreateDto);
            messageModel.SendTime = DateTime.Now;

            await _messageRepository.Create(messageModel);
            await _messageRepository.SaveChanges();

            return _mapper.Map <MessageReadDto>(messageModel);
        }

        public async Task<Match> GetMatchById(int id)
        {
            return await _matchRepository.GetById(id);
        }
    }
}
