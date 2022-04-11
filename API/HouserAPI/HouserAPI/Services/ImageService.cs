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
using HouserAPI.DTOs.Offer;

namespace HouserAPI.Services
{
    public class ImageService : IImageService
    {
        private readonly ImageRepository _repository;
        private readonly IOfferService _offerService;
        private readonly IMapper _mapper;
        private readonly IHostEnvironment _hostEnvironment;

        public ImageService(IRepository<Image> repository, IOfferService offerService, IMapper mapper, IHostEnvironment hostEnvironment)
        {
            _repository = repository as ImageRepository;
            _offerService = offerService;
            _mapper = mapper;
            _hostEnvironment = hostEnvironment;
        }

        public async Task<ImageReadDto> CreateUserImage(string userId, IFormFile image)
        {
            return await Create(userId, 0, $"Images/User/{userId}", image);
        }

        public async Task<ImageReadDto> CreateOfferImage(string userId, OfferReadDto offer, IFormFile image)
        {
            return await Create(userId, offer.Id, $"Images/Offer/{offer.Id}", image);
        }

        private async Task<ImageReadDto> Create(string userId, int offerId, string imageDirectory, IFormFile image)
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
                OfferId = offerId != 0 ? offerId : null
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
                if (image.OfferId != null)// in offer
                {
                    var offer = await _offerService.GetById((int)image.OfferId);
                    var currentlyMainImage = offer.Images.FirstOrDefault(x => x.IsMain);
                    if (currentlyMainImage != null)
                        currentlyMainImage.IsMain = false;
                }
                else // in user
                {
                    var userImages = await GetAllByUser(imageUpdateDto.UserId);
                    var currentlyMainImage = userImages.FirstOrDefault(x => x.IsMain);
                    if (currentlyMainImage != null)
                        currentlyMainImage.IsMain = false;
                }
            }

            _mapper.Map(imageUpdateDto, image);
            await _repository.Update(image);
            return await _repository.SaveChanges();
        }
    }
}
