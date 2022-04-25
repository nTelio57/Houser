using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Messenger.Auth;
using Messenger.DTOs.Message;
using Messenger.Models;
using Messenger.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace Messenger.Hubs
{
    
    public class ChatHub : Hub
    {
        private readonly IMessageService _messageService;
        private static readonly Dictionary<string, string> ConnectedUsers = new();
        private static readonly List<Match> Matches = new();

        public ChatHub(IMessageService messageService)
        {
            _messageService = messageService;
        }

        private static Match GetMatch(int matchId) =>
            Matches.FirstOrDefault(match => match.Id == matchId);
        
        public async Task SendMessage(int matchId, string senderUserId, string message)
        {
            MessageCreateDto newMessage = new MessageCreateDto
            {
                MatchId = matchId, SenderId = senderUserId, Content = message
            };

            await _messageService.Create(newMessage);
            
            var match = await _messageService.GetMatchById(matchId);
            if (match == null)
                return;

            var receiverId = match.GetReceiverId(senderUserId);
            if (string.IsNullOrEmpty(receiverId))
                return;
            
            var connectionIds = ConnectedUsers.Where(x => x.Value == receiverId).Select(x => x.Key).ToList();
            foreach (string connectionId in connectionIds)
            {
                await Clients.Client(connectionId).SendAsync("ReceiveMessage", matchId, senderUserId, message);
            }
        }

        public async Task Login(string userId)
        {
            ConnectedUsers.Add(Context.ConnectionId, userId);
        }

        public async Task Disconnect(string userId)
        {
            ConnectedUsers.Add(Context.ConnectionId, userId);
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            var userId = ConnectedUsers[Context.ConnectionId];
            var connectionIds = ConnectedUsers.Where(x => x.Value == userId).Select(x => x.Key).ToList();
            foreach (string connectionId in connectionIds)
            {
                ConnectedUsers.Remove(connectionId);
            }

            await base.OnDisconnectedAsync(exception);
        }
    }
}
