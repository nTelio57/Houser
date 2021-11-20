using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Image;
using HouserAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace HouserAPI.Services
{
    public class ImageService : IImageService
    {
        private readonly ImageRepository _repository;
        private readonly IMapper _mapper;
        private readonly IHostEnvironment _hostEnvironment;

        public ImageService(IRepository<Image> repository, IMapper mapper, IHostEnvironment hostEnvironment)
        {
            _repository = repository as ImageRepository;
            _mapper = mapper;
            _hostEnvironment = hostEnvironment;
        }

        public async Task<ImageReadDto> Create(string userId, IFormFile image)
        {
            string extension = Path.GetExtension(image.FileName);
            string fileName = DateTime.Now.ToString("yyyyMMddHHmmssff") + extension;
            string directory = Path.Combine(_hostEnvironment.ContentRootPath, $"Images/{userId}");
            string fullPath = Path.Combine($"{directory}/{fileName}");

            Directory.CreateDirectory(directory);
            await using (var stream = new FileStream(fullPath, FileMode.Create))
            {
                await image.CopyToAsync(stream);
            }

            var newImage = new Image
            {
                Path = fullPath,
                UserId = userId
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

            File.Delete(image.Path);
            await _repository.Delete(image);
            return await _repository.SaveChanges();
        }
    }
}
