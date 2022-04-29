using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Messenger.DTOs.Message;
using Messenger.Models;
using Messenger.Services;
using Microsoft.AspNetCore.SignalR;

namespace Messenger.Hubs
{
    
    public class ChatHub : Hub
    {
        private readonly IMessageService _messageService;
        private static readonly Dictionary<string, string> ConnectedUsers = new();

        public ChatHub(IMessageService messageService)
        {
            _messageService = messageService;
        }
        
        public async Task SendMessage(int matchId, string senderUserId, string message)
        {
            var newMessage = new MessageCreateDto
            {
                MatchId = matchId, SenderId = senderUserId, Content = message
            };

            await _messageService.Create(newMessage);
            
            var match = await _messageService.GetMatchById(matchId);
            if (match == null)
                return;

            string receiverId = match.GetReceiverId(senderUserId);
            if (string.IsNullOrEmpty(receiverId))
                return;
            
            var connectionIds = ConnectedUsers.Where(x => x.Value == receiverId).Select(x => x.Key).ToList();
            foreach (string connectionId in connectionIds)
            {
                await Clients.Client(connectionId).SendAsync("ReceiveMessage", matchId, senderUserId, message);
            }

            var senderConnectionIds = ConnectedUsers.Where(x => x.Value == senderUserId).Select(x => x.Key).ToList();
            foreach (string connectionId in senderConnectionIds)
            {
                await Clients.Client(connectionId).SendAsync("ReceiveMessage", matchId, senderUserId, message);
            }
        }

        public async Task Login(string userId)
        {
            ConnectedUsers.Add(Context.ConnectionId, userId);
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            ConnectedUsers.Remove(Context.ConnectionId);

            await base.OnDisconnectedAsync(exception);
        }
    }
}
