using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using HouserAPI.Models;
using HouserAPI.Services;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RecommendationController : ControllerBase
    {
        private readonly IRecommendationService _recommendationService;

        public RecommendationController(IRecommendationService recommendationService)
        {
            _recommendationService = recommendationService;
        }

        [HttpPost("room/{count}/{offset}")]
        public async Task<IActionResult> GetRoomRecommendationByFilter(int count, int offset, RoomFilter roomFilter)
        {
            var offerReadDto = await _recommendationService.GetRoomRecommendationByFilter(count, offset, roomFilter);

            return Ok(offerReadDto);
        }
    }
}
