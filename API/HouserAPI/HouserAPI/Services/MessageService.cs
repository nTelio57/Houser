﻿using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Message;
using HouserAPI.Models;

namespace HouserAPI.Services
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

        public async Task<Match> GetMatchById(int id)
        {
            return await _matchRepository.GetById(id);
        }
    }
}
