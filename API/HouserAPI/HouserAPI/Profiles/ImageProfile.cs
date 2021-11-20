using AutoMapper;
using HouserAPI.DTOs.Image;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class ImageProfile : Profile
    {
        public ImageProfile()
        {
            CreateMap<Image, ImageReadDto>();
        }
    }
}
