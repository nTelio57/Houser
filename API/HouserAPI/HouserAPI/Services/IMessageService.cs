using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Message;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public interface IMessageService
    {
        Task<MessageReadDto> Create(MessageCreateDto messageCreateDto);
        Task<IEnumerable<MessageReadDto>> GetAllByMatchId(int matchId);
        Task<Match> GetMatchById(int id);
    }
}
