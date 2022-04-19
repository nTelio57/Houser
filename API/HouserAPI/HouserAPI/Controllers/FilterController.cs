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

        [HttpGet("{id}")]
        public async Task<IActionResult> GetFilterByUserId(string id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var filterReadDto = await _filterService.GetByUserId(id);
            if (filterReadDto is null)
                return NotFound();

            return Ok(filterReadDto);
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

        [HttpPost("user")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> CreateUserFilter(UserFilterCreateDto userFilterCreateDto)
        {
            if (userFilterCreateDto is null)
                return BadRequest("Value cannot be null.");

            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            try
            {
                var filterReadDto = await _filterService.Create(userFilterCreateDto, userId);
                return CreatedAtAction(nameof(CreateRoomFilter), filterReadDto);
            }
            catch (Exception e)
            {
                return BadRequest($"Failed to create user filter. {e.Message}");
            }
        }
    }
}
