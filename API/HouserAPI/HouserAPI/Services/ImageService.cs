using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Image;
using HouserAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using HouserAPI.DTOs.Room;

namespace HouserAPI.Services
{
    public class ImageService : IImageService
    {
        private readonly ImageRepository _repository;
        private readonly IRoomService _roomService;
        private readonly IMapper _mapper;
        private readonly IHostEnvironment _hostEnvironment;

        public ImageService(IRepository<Image> repository, IRoomService roomService, IMapper mapper, IHostEnvironment hostEnvironment)
        {
            _repository = repository as ImageRepository;
            _roomService = roomService;
            _mapper = mapper;
            _hostEnvironment = hostEnvironment;
        }

        public async Task<ImageReadDto> CreateUserImage(string userId, IFormFile image)
        {
            var userImages = await GetAllByUser(userId);
            var mainImage = userImages.Where(x => x.RoomId == null).FirstOrDefault(x => x.IsMain);

            return await Create(userId, 0, $"Images/User/{userId}", mainImage == null, image);
        }

        public async Task<ImageReadDto> CreateRoomImage(string userId, RoomReadDto room, IFormFile image)
        {
            return await Create(userId, room.Id, $"Images/Room/{room.Id}", false, image);
        }

        private async Task<ImageReadDto> Create(string userId, int roomId, string imageDirectory, bool isMain, IFormFile image)
        {
            string extension = Path.GetExtension(image.FileName);
            string fileName = DateTime.Now.ToString("yyyyMMddHHmmssff") + extension;
            string directory = Path.Combine(_hostEnvironment.ContentRootPath, imageDirectory);
            string fullPath = Path.Combine($"{directory}/{fileName}");

            Directory.CreateDirectory(directory);
            await using (var stream = new FileStream(fullPath, FileMode.Create))
            {
                await image.CopyToAsync(stream);
            }

            var newImage = new Image
            {
                Path = fullPath,
                UserId = userId,
                RoomId = roomId != 0 ? roomId : null,
                IsMain = isMain
            };

            await _repository.Create(newImage);
            await _repository.SaveChanges();

            return _mapper.Map<ImageReadDto>(newImage);
        }

        public async Task<IEnumerable<ImageReadDto>> GetAll()
        {
            var images = await _repository.GetAll();
            return _mapper.Map<IEnumerable<ImageReadDto>>(images);
        }

        public async Task<IEnumerable<ImageReadDto>> GetAllByUser(string id)
        {
            var images = await _repository.GetAllByUser(id);
            images = images.Where(x => x.RoomId == null);
            return _mapper.Map<IEnumerable<ImageReadDto>>(images);
        }

        public async Task<ImageReadDto> GetById(int id)
        {
            var image = await _repository.GetById(id);
            return _mapper.Map<ImageReadDto>(image);
        }

        public async Task<bool> Delete(int id)
        {
            var image = await _repository.GetById(id);
            if (image == null)
                return false;

            if (image.IsMain)
            {
                if (image.RoomId != null)// in room
                {
                    var room = await _roomService.GetById((int)image.RoomId);
                    var defaultImageDto = room.Images.FirstOrDefault();
                    if (defaultImageDto != null)
                    {
                        var defaultImage = await _repository.GetById(defaultImageDto.Id);
                        defaultImage.IsMain = true;
                        await _repository.Update(defaultImage);
                    }
                }
                else // in user
                {
                    var userImages = await _repository.GetAllByUser(image.UserId);
                    userImages = userImages.Where(x => x.RoomId == null);
                    var defaultImage = userImages.FirstOrDefault();
                    if (defaultImage != null)
                    {
                        defaultImage.IsMain = true;
                        await _repository.Update(defaultImage);
                    }
                }
            }

            try
            {
                File.Delete(image.Path);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Failed to delete image file of id {id} with error: {e.Message}");
            }
            
            await _repository.Delete(image);
            return await _repository.SaveChanges();
        }

        public async Task<bool> Update(int id, ImageUpdateDto imageUpdateDto)
        {
            var image = await _repository.GetById(id);

            //is set as main image
            if (imageUpdateDto.IsMain)
            {
                if (image.RoomId != null)// in room
                {
                    var room = await _roomService.GetById((int)image.RoomId);
                    var currentlyMainImage = room.Images.FirstOrDefault(x => x.IsMain);
                    if (currentlyMainImage != null)
                    {
                        currentlyMainImage.IsMain = false;
                        await _repository.Update(currentlyMainImage);
                    }
                }
                else // in user
                {
                    var userImages = await _repository.GetAllByUser(imageUpdateDto.UserId);
                    var currentlyMainImage = userImages.Where(x => x.RoomId == null).FirstOrDefault(x => x.IsMain);
                    if (currentlyMainImage != null)
                    {
                        currentlyMainImage.IsMain = false;
                        await _repository.Update(currentlyMainImage);
                    }
                }
            }

            _mapper.Map(imageUpdateDto, image);
            await _repository.Update(image);
            return await _repository.SaveChanges();
        }
    }
}
