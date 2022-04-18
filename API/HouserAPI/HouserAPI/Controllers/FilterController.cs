using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.DTOs.Filter;
using HouserAPI.Services;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FilterController : ControllerBase
    {
        private readonly IFilterService _filterService;

        public FilterController(IFilterService filterService)
        {
            _filterService = filterService;
        }

        [HttpPost("room")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> CreateRoomFilter(RoomFilterCreateDto roomFilterCreateDto)
        {
            if (roomFilterCreateDto is null)
                return BadRequest("Value cannot be null.");

            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            try
            {
                var filterReadDto = await _filterService.Create(roomFilterCreateDto, userId);
                return CreatedAtAction(nameof(CreateRoomFilter), filterReadDto);
            }
            catch (Exception e)
            {
                return BadRequest($"Failed to create room filter. {e.Message}");
            }
        }
    }
}
