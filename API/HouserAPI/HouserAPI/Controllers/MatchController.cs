using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.DTOs.Swipe;
using HouserAPI.Services;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MatchController : ControllerBase
    {
        private readonly IMatchService _matchService;

        public MatchController(IMatchService matchService)
        {
            _matchService = matchService;
        }

        [HttpPost("swipe")]
        public async Task<IActionResult> Swipe(SwipeCreateDto swipeCreateDto)
        {
            if (swipeCreateDto is null)
                return BadRequest("Value cannot be null.");

            string userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != swipeCreateDto.SwiperId)
                return Forbid();

            try
            {
                var swipeReadDto = await _matchService.Swipe(swipeCreateDto);
                return CreatedAtAction(nameof(Swipe), swipeReadDto);
            }
            catch (Exception e)
            {
                return BadRequest($"Failed to register a swipe. {e.Message}");
            }
        }

        [HttpGet("user/{id}")]
        public async Task<IActionResult> GetAllMatchesByUser(string id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var rooms = await _matchService.GetAllByUser(id);
            return Ok(rooms);
        }
    }
}
