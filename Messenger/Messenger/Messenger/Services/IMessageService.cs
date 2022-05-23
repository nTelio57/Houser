using System.Threading.Tasks;
using Messenger.DTOs.Message;
using Messenger.Models;

namespace Messenger.Services
{
    public interface IMessageService
    {
        Task<MessageReadDto> Create(MessageCreateDto messageCreateDto);
        Task<Match> GetMatchById(int id);
    }
}
