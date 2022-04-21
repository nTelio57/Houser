using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Room;

namespace HouserAPI.Services
{
    public interface IRoomService
    {
        Task<RoomReadDto> Create(RoomCreateDto roomCreateDto);
        Task<IEnumerable<RoomReadDto>> GetAll();
        Task<RoomReadDto> GetById(int id);
        Task<IEnumerable<RoomReadDto>> GetAllByUser(string id);

        Task<bool> Update(int id, RoomUpdateDto roomUpdateDto);
        Task<bool> Delete(int id);
    }
}
