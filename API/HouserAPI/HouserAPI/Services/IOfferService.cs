using System.Collections.Generic;
using System.Threading.Tasks;
using HouserAPI.DTOs.Offer;

namespace HouserAPI.Services
{
    public interface IOfferService
    {
        Task<OfferReadDto> Create(OfferCreateDto offerCreateDto);
        Task<IEnumerable<OfferReadDto>> GetAll();
        Task<OfferReadDto> GetById(int id);
        Task<IEnumerable<OfferReadDto>> GetAllByUser(string id);

        Task<bool> Update(int id, OfferUpdateDto offerUpdateDto);
        Task<bool> Delete(int id);
    }
}
