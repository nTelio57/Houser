using System;
using System.Threading.Tasks;
using Messenger.Auth;
using Messenger.DTOs.Message;
using Messenger.Services;
using Microsoft.AspNetCore.Mvc;

namespace Messenger.Controllers
{
    [Route("[controller]")]
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
        public async Task<IActionResult> GetAllMessagesByMatch(int id)
        {
            var messages = await _messageService.GetAllByMatchId(id);
            return Ok(messages);
        }
    }
}
