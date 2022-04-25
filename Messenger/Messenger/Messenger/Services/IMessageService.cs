using System.Collections.Generic;
using System.Threading.Tasks;
using Messenger.DTOs.Match;
using Messenger.DTOs.Message;

namespace Messenger.Services
{
    public interface IMessageService
    {
        Task<MessageReadDto> Create(MessageCreateDto messageCreateDto);
        Task<IEnumerable<MessageReadDto>> GetAllByMatchId(int matchId);
        Task<MatchReadDto> GetMatchById(int id);
    }
}
