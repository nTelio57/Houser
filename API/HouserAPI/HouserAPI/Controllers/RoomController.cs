using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.DTOs.Room;
using HouserAPI.Services;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RoomController : ControllerBase
    {
        private readonly IRoomService _roomService;
        private readonly IImageService _imageService;

        public RoomController(IRoomService roomService, IImageService imageService)
        {
            _roomService = roomService;
            _imageService = imageService;
        }

        [HttpPost]
        public async Task<IActionResult> CreateRoom(RoomCreateDto roomCreateDto)
        {
            if(roomCreateDto is null)
                return BadRequest("Value cannot be null.");

            try
            {
                var roomReadDto = await _roomService.Create(roomCreateDto);
                return CreatedAtAction(nameof(CreateRoom), roomReadDto);
            }
            catch (Exception e)
            {
                return BadRequest($"Failed to create room. {e.Message}");
            }
        }

        [HttpGet("{id}", Name = "GetRoomById")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetRoomById(int id)
        {
            var roomReadDto = await _roomService.GetById(id);
            if (roomReadDto is null) 
                return NotFound();

            return Ok(roomReadDto);
        }

        [HttpGet("user/{id}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetAllRoomsByUser(string id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;
            if (userId != id)
                return Forbid();

            var rooms = await _roomService.GetAllByUser(id);
            return Ok(rooms);
        }

        [HttpPut("{id}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> UpdateRoom(int id, RoomUpdateDto roomUpdateDto)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            var room = await _roomService.GetById(id);
            if (room == null)
                return NotFound();

            if (userId != room.UserId)
                return Forbid();

            await _roomService.Update(id, roomUpdateDto);

            return NoContent();

        }

        [HttpDelete("{id}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> DeleteRoom(int id)
        {
            var userId = User.FindFirst(CustomClaims.UserId)?.Value;

            var room = await _roomService.GetById(id);
            if (room is null)
                return NotFound();

            if (userId != room.UserId)
                return Forbid();

            foreach (var image in room.Images)
                await _imageService.Delete(image.Id);
            
            if (await _roomService.Delete(id))
                return NoContent();
            return BadRequest();
        }
    }
}
