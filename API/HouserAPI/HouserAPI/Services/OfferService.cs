using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Offer;
using HouserAPI.Models;

namespace HouserAPI.Services
{
    public class OfferService : IOfferService
    {
        private readonly OfferRepository _repository;
        private readonly IMapper _mapper;

        public OfferService(IRepository<Offer> repository, IMapper mapper)
        {
            _repository = repository as OfferRepository;
            _mapper = mapper;
        }

        public async Task<OfferReadDto> Create(OfferCreateDto offerCreateDto)
        {
            if (offerCreateDto is null) throw new ArgumentNullException((nameof(offerCreateDto)));

            var offerModel = _mapper.Map<Offer>(offerCreateDto);
            await _repository.Create(offerModel);
            await _repository.SaveChanges();

            return _mapper.Map<OfferReadDto>(offerModel);
        }

        public async Task<IEnumerable<OfferReadDto>> GetAll()
        {
            throw new NotImplementedException();
        }

        public async Task<OfferReadDto> GetById(int id)
        {
            var offer = await _repository.GetById(id);
            return _mapper.Map<OfferReadDto>(offer);
        }

        public async Task<IEnumerable<OfferReadDto>> GetAllByUser(string id)
        {
            var offers = await _repository.GetAllByUser(id);
            return _mapper.Map<IEnumerable<OfferReadDto>>(offers);
        }

        public async Task<bool> Update(int id, OfferUpdateDto offerUpdateDto)
        {
            var offer = await _repository.GetById(id);
            _mapper.Map(offerUpdateDto, offer);
            await _repository.Update(offer);
            return await _repository.SaveChanges();
        }

        public async Task<bool> Delete(int id)
        {
            var offer = await _repository.GetById(id);
            if (offer is null)
                return false;

            await _repository.Delete(offer);
            return await _repository.SaveChanges();
        }
    }
}
