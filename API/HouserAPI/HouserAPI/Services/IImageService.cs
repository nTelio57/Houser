using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Image;
using Microsoft.AspNetCore.Http;

namespace HouserAPI.Services
{
    public interface IImageService
    {
        Task<ImageReadDto> Create(string userId, IFormFile image);
        Task<IEnumerable<ImageReadDto>> GetAll();
        Task<ImageReadDto> GetById(int id);
        Task<IEnumerable<ImageReadDto>> GetAllByUser(string id);
        Task<bool> Delete(int id);
    }
}
