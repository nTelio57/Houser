using Messenger.Auth;
using Microsoft.AspNetCore.SignalR;

namespace Messenger.Utils
{
    public class CustomUserIdProvider : IUserIdProvider
    {
        public string GetUserId(HubConnectionContext connection)
        {
            return connection.User?.FindFirst(CustomClaims.ClientId)?.Value;
        }
    }
}
