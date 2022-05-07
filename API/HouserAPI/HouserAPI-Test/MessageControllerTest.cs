using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.DTOs.Message;
using HouserAPI.DTOs.Room;
using HouserAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace HouserAPI_Test
{
    public class MessageControllerTest
    {
        private readonly Mock<IMessageService> _mockMessageService;
        private readonly MessageController _controller;
        public MessageControllerTest()
        {
            _mockMessageService = new Mock<IMessageService>();

            _controller = GetMessageController(_mockMessageService.Object);
        }

        private static ClaimsPrincipal MockUser()
        {
            return new(new ClaimsIdentity(new Claim[]
            {
                new (CustomClaims.UserId, "UserId"),
            }, "mock"));
        }

        private static MessageController GetMessageController(IMessageService mockMessageService)
        {
            return new MessageController(mockMessageService)
            {
                ControllerContext = new ControllerContext
                {
                    HttpContext = new DefaultHttpContext()
                    {
                        Request =
                        {
                            Scheme = "http",
                            Host = new HostString("localhost")
                        },
                        User = MockUser()
                    },
                },
            };
        }

        private readonly MessageCreateDto _mockMessageCreateDto = new()
        {
            Content = "Message"
        };

        private readonly MessageReadDto _mockMessageReadDto = new()
        {
            Id = 1,
            Content = "Message"
        };

        [Fact]
        public async Task CreateRoom_ReturnsBadRequest()
        {
            var result = await _controller.CreateMessage(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateRoom_ReturnsRoomReadDto()
        {
            _mockMessageService
                .Setup(x => x.Create(It.IsAny<MessageCreateDto>()))
                .ReturnsAsync(_mockMessageReadDto);

            var result = await _controller.CreateMessage(_mockMessageCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var expected = resultObject?.Value as MessageReadDto;

            Assert.Equal(_mockMessageReadDto, expected);
        }

        [Fact]
        public async Task CreateRoom_ReturnsBadRequestCatch()
        {
            _mockMessageService
                .Setup(x => x.Create(It.IsAny<MessageCreateDto>()))
                .ThrowsAsync(new ArgumentNullException());

            var result = await _controller.CreateMessage(_mockMessageCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetAllMessagesByMatch_ReturnsOk()
        {
            var messageList = new Collection<MessageReadDto>() { _mockMessageReadDto };
            _mockMessageService
                .Setup(x => x.GetAllByMatchId(It.IsAny<int>()))
                .ReturnsAsync(messageList);

            var result = await _controller.GetAllMessagesByMatch(1);
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as Collection<MessageReadDto>;

            Assert.Equal(messageList, actual);
        }
    }
}
