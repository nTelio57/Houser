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
            string userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (roomFilter.UserId != userId)
                return Forbid();

            try
            {
                var roomReadDto = await _recommendationService.GetRoomRecommendationByFilter(count, offset, roomFilter, userId);
                return Ok(roomReadDto);
            }
            catch
            {
                return BadRequest("Failed to get recommendations");
            }
        }

        [HttpPost("user/{count}/{offset}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetUserRecommendationByFilter(int count, int offset, UserFilter userFilter)
        {
            string userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userFilter.UserId != userId)
                return Forbid();

            try
            {
                var userReadDto = await _recommendationService.GetUserRecommendationByFilter(count, offset, userFilter, userId);
                return Ok(userReadDto);
            }
            catch
            {
                return BadRequest("Failed to get recommendations");
            }
        }
    }
}
