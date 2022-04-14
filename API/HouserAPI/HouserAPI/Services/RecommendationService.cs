using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Offer;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public class RecommendationService : IRecommendationService
    {
        private readonly OfferRepository _offerRepository;
        private readonly IMapper _mapper;

        public RecommendationService(IRepository<Offer> repository, IMapper mapper)
        {
            _offerRepository = repository as OfferRepository;
            _mapper = mapper;
        }

        public async Task<OfferReadDto> GetRoomRecommendationByFilter()
        {
            var offer = await _offerRepository.GetFirstRandom();

            return _mapper.Map<OfferReadDto>(offer);
        }
    }
}
