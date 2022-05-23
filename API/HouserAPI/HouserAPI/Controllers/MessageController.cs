using System;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.DTOs.Message;
using HouserAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace HouserAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MessageController : ControllerBase
    {
        private readonly IMessageService _messageService;

        public MessageController(IMessageService messageService)
        {
            _messageService = messageService;
        }

        [HttpPost]
        public async Task<IActionResult> CreateMessage(MessageCreateDto messageCreateDto)
        {
            if (messageCreateDto is null)
                return BadRequest("Value cannot be null.");

            try
            {
                var messageReadDto = await _messageService.Create(messageCreateDto);
                return CreatedAtAction(nameof(CreateMessage), messageReadDto);
            }
            catch (Exception e)
            {
                return BadRequest($"Failed to create message. {e.Message}");
            }
        }

        [HttpGet("match/{id}")]
        [Roles(UserRoles.Basic)]
        public async Task<IActionResult> GetAllMessagesByMatch(int id)
        {
            var messages = await _messageService.GetAllByMatchId(id);
            return Ok(messages);
        }
    }
}
