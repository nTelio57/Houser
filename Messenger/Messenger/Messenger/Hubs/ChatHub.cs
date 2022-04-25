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
        private static readonly List<string> ConnectedUsers = new();
        private static readonly List<Match> Matches = new();

        public ChatHub(IMessageService messageService)
        {
            _messageService = messageService;
        }

        private static Match GetMatch(int matchId) =>
            Matches.FirstOrDefault(match => match.Id == matchId);
        public async Task SendMessage(int matchId, string senderUserId, string message)
        {
            MessageCreateDto newMessage = new MessageCreateDto();
            newMessage.MatchId = matchId;
            newMessage.SenderId = senderUserId;
            newMessage.Content = message;

            await _messageService.Create(newMessage);

            Match match = GetMatch(matchId);
            if (match == null)
                return;

            var receiver = match.GetReceiver(senderUserId);
            if (receiver == null)
                return;

            await Clients.All.SendAsync("ReceiveMessage", senderUserId, message);
        }
        public override async Task OnConnectedAsync()
        {
            var name = Context.User.Identity.Name;
            ConnectedUsers.Add(Context.ConnectionId);
            await Groups.AddToGroupAsync(Context.ConnectionId, "ChatRoom");
            await base.OnConnectedAsync();
        }
    }
}
