﻿using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using Messenger.Data;
using Messenger.DTOs.Match;
using Messenger.DTOs.Message;
using Messenger.Models;

namespace Messenger.Services
{
    public class MessageService : IMessageService
    {
        private readonly IMapper _mapper;
        private readonly MatchRepository _matchRepository;
        private readonly MessageRepository _messageRepository;

        public MessageService(IMapper mapper, IRepository<Message> messageRepository, IRepository<Match> matchRepository)
        {
            _mapper = mapper;
            _matchRepository = matchRepository as MatchRepository;
            _messageRepository = messageRepository as MessageRepository;
        }

        public async Task<IEnumerable<MessageReadDto>> GetAllByMatchId(int matchId)
        {
            var messages = await _messageRepository.GetAllByMatchId(matchId);
            return _mapper.Map<IEnumerable<MessageReadDto>>(messages);
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

        public async Task<MatchReadDto> GetMatchById(int id)
        {
            var match = await _matchRepository.GetById(id);
            return _mapper.Map<MatchReadDto>(match);
        }
    }
}
