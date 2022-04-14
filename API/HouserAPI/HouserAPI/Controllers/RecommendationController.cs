using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
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

        [HttpGet]
        public async Task<IActionResult> GetRoomRecommendationByFilter()
        {
            var offerReadDto = await _recommendationService.GetRoomRecommendationByFilter();
            if (offerReadDto is null)
                return NotFound();

            return Ok(offerReadDto);
        }
    }
}
