using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using HouserAPI.Auth;
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
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetRoomRecommendationByFilter(int count, int offset, RoomFilter roomFilter)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            var offerReadDto = await _recommendationService.GetRoomRecommendationByFilter(count, offset, roomFilter, userId);

            return Ok(offerReadDto);
        }
    }
}
