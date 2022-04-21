using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Image;
using HouserAPI.DTOs.Room;
using Microsoft.AspNetCore.Http;

namespace HouserAPI.Services
{
    public interface IImageService
    {
        Task<ImageReadDto> CreateUserImage(string userId, IFormFile image);
        Task<ImageReadDto> CreateRoomImage(string userId, RoomReadDto room, IFormFile image);
        Task<IEnumerable<ImageReadDto>> GetAll();
        Task<ImageReadDto> GetById(int id);
        Task<IEnumerable<ImageReadDto>> GetAllByUser(string id);
        Task<bool> Update(int id, ImageUpdateDto imageUpdateDto);
        Task<bool> Delete(int id);
    }
}
