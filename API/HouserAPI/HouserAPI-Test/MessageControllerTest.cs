using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.Data;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Message;
using HouserAPI.Models;
using HouserAPI.Profiles;
using HouserAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using Newtonsoft.Json;
using Xunit;

namespace HouserAPI_Test
{
    public class MessageControllerTest
    {
        private readonly IMessageService _messageService;
        private readonly Mock<MessageRepository> _mockMessageRepository;
        private readonly IMapper _mapper;
        public MessageControllerTest()
        {
            var mapperConfig = new ConfigurationProfile().Configure();
            _mapper = mapperConfig.CreateMapper();

            var options = new DbContextOptionsBuilder<DatabaseContext>()
                .UseInMemoryDatabase("IN_MEMORY_DATABASE")
                .Options;
            var mockDatabaseContext = new Mock<DatabaseContext>(options);

            _mockMessageRepository = new Mock<MessageRepository>(mockDatabaseContext.Object);
            var mockMatchRepository = new Mock<MatchRepository>(mockDatabaseContext.Object);
            _messageService = new MessageService(_mapper, _mockMessageRepository.Object, mockMatchRepository.Object);
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
            Content = "Message",
            SenderId = "UserId",
            MatchId = 0
        };

        private readonly MessageReadDto _mockMessageReadDto = new()
        {
            Id = 0,
            Content = "Message",
            SenderId = "UserId",
            MatchId = 0
        };

        private readonly Message _mockMessage = new()
        {
            Id = 0,
            Content = "Message",
            SenderId = "UserId",
            MatchId = 0,
            Sender = null,
            Match = null
        };

        [Fact]
        public async Task CreateRoom_ReturnsBadRequest()
        {
            var controller = GetMessageController(_messageService);

            var result = await controller.CreateMessage(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateRoom_ReturnsMessageReadDto()
        {
            _mockMessageRepository
                .Setup(x => x.Create(It.IsAny<Message>()))
                .Returns(Task.FromResult(_mockMessage));

            var controller = GetMessageController(_messageService);

            var expected = _mockMessageReadDto;
            var result = await controller.CreateMessage(_mockMessageCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var actual = resultObject?.Value as MessageReadDto;

            var dateTime = DateTime.Now;
            expected.SendTime = dateTime;
            if(actual != null)
                actual.SendTime = dateTime;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task CreateRoom_ReturnsBadRequestCatch()
        {
            var mockMessageService = new Mock<IMessageService>();
            mockMessageService
                .Setup(x => x.Create(It.IsAny<MessageCreateDto>()))
                .ThrowsAsync(new ArgumentNullException());

            var controller = GetMessageController(mockMessageService.Object);

            var result = await controller.CreateMessage(_mockMessageCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetAllMessagesByMatch_ReturnsOk()
        {
            var messageList = new Collection<Message>() { _mockMessage };
            _mockMessageRepository
                .Setup(x => x.GetAllByMatchId(It.IsAny<int>()))
                .ReturnsAsync(messageList);
            var expected = _mapper.Map<IEnumerable<MessageReadDto>>(messageList);

            var controller = GetMessageController(_messageService);

            var result = await controller.GetAllMessagesByMatch(1);
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as IEnumerable<MessageReadDto>;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }
    }
}
