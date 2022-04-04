using AutoMapper;
using HouserAPI.DTOs.Offer;
using HouserAPI.Models;

namespace HouserAPI.Profiles
{
    public class OfferProfile : Profile
    {
        public OfferProfile()
        {
            CreateMap<Offer, OfferReadDto>();
            CreateMap<OfferCreateDto, Offer>();
            CreateMap<OfferUpdateDto, Offer>();
            CreateMap<Offer, OfferUpdateDto>();
        }
    }
}
