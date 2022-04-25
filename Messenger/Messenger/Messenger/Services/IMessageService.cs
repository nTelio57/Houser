using System.Collections.Generic;
using System.Threading.Tasks;
using Messenger.DTOs.Match;
using Messenger.DTOs.Message;
using Messenger.Models;

namespace Messenger.Services
{
    public interface IMessageService
    {
        Task<MessageReadDto> Create(MessageCreateDto messageCreateDto);
        Task<IEnumerable<MessageReadDto>> GetAllByMatchId(int matchId);
        Task<Match> GetMatchById(int id);
    }
}
