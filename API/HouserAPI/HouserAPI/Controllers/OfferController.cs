using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.DTOs.Offer;
using HouserAPI.Services;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OfferController : ControllerBase
    {
        private readonly IOfferService _offerService;
        private readonly IImageService _imageService;

        public OfferController(IOfferService offerService, IImageService imageService)
        {
            _offerService = offerService;
            _imageService = imageService;
        }

        [HttpPost]
        public async Task<IActionResult> CreateOffer(OfferCreateDto offerCreateDto)
        {
            if(offerCreateDto is null)
                return BadRequest("Value cannot be null.");

            try
            {
                var offerReadDto = await _offerService.Create(offerCreateDto);
                return CreatedAtAction(nameof(CreateOffer), offerReadDto);
            }
            catch (Exception e)
            {
                return BadRequest($"Failed to create offer. {e.Message}");
            }
        }

        [HttpGet("{id}", Name = "GetOfferById")]
        public async Task<IActionResult> GetOfferById(int id)
        {
            var offerReadDto = await _offerService.GetById(id);
            if (offerReadDto is null) 
                return NotFound();

            return Ok(offerReadDto);
        }

        [HttpGet("user/{id}")]
        public async Task<IActionResult> GetAllOffersByUser(string id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var offers = await _offerService.GetAllByUser(id);
            return Ok(offers);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateOffer(int id, OfferUpdateDto offerUpdateDto)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            var offer = await _offerService.GetById(id);
            if (offer == null)
                return NotFound();

            if (userId != offer.UserId)
                return Forbid();

            await _offerService.Update(id, offerUpdateDto);

            return NoContent();

        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOffer(int id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            var offer = await _offerService.GetById(id);
            if (offer is null)
                return NotFound();

            if (userId != offer.UserId)
                return Forbid();

            foreach (var image in offer.Images)
                await _imageService.Delete(image.Id);
            
            if (await _offerService.Delete(id))
                return NoContent();
            return BadRequest();
        }
    }
}
