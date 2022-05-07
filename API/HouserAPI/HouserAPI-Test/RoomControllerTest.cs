using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Security.Claims;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.DTOs.Image;
using HouserAPI.DTOs.Room;
using HouserAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace HouserAPI_Test
{
    public class RoomControllerTest
    {
        private readonly Mock<IRoomService> _mockRoomService;
        private readonly Mock<IImageService> _mockImageService;
        private readonly RoomController _controller;
        public RoomControllerTest()
        {
            _mockRoomService = new Mock<IRoomService>();
            _mockImageService = new Mock<IImageService>();

            _controller = GetRoomController(_mockRoomService.Object, _mockImageService.Object);
        }

        private static ClaimsPrincipal MockUser()
        {
            return new (new ClaimsIdentity(new Claim[]
            {
                new (CustomClaims.UserId, "UserId"),
            }, "mock"));
        }

        private static RoomController GetRoomController(IRoomService roomService, IImageService imageService)
        {
            return new(roomService, imageService)
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

        private readonly RoomCreateDto _mockCreateReadDto = new()
        {
            UserId = "UserId",
            Title = "Title",
            City = "City",
            Address = "Address",
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 02, 01),
        };

        private readonly RoomReadDto _mockRoomReadDto = new()
        {
            Id = 1,
            UserId = "UserId",
            Title = "Title",
            City = "City",
            Address = "Address",
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 02, 01),
            Images = new List<ImageReadDto>()
        };

        private readonly RoomUpdateDto _mockRoomUpdateDto = new()
        {
            Title = "Title",
            City = "City",
            Address = "Address",
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 02, 01),
        };

        [Fact]
        public async Task CreateRoom_ReturnsBadRequest()
        {
            var result = await _controller.CreateRoom(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateRoom_ReturnsRoomReadDto()
        {
            _mockRoomService
                .Setup(x => x.Create(It.IsAny<RoomCreateDto>()))
                .ReturnsAsync(_mockRoomReadDto);

            var result = await _controller.CreateRoom(_mockCreateReadDto);
            var resultObject = result as CreatedAtActionResult;
            var expected = resultObject?.Value as RoomReadDto;

            Assert.Equal(_mockRoomReadDto, expected);
        }

        [Fact]
        public async Task CreateRoom_ReturnsBadRequestCatch()
        {
            _mockRoomService
                .Setup(x => x.Create(It.IsAny<RoomCreateDto>()))
                .ThrowsAsync(new ArgumentNullException());

            var result = await _controller.CreateRoom(_mockCreateReadDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetRoomById_ReturnsNotFound()
        {
            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((RoomReadDto) null);

            var result = await _controller.GetRoomById(1);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task GetRoomById_ReturnsRoomReadDto()
        {
            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoomReadDto);

            var result = await _controller.GetRoomById(1);
            var resultObject = result as OkObjectResult;
            var expected = resultObject?.Value as RoomReadDto;

            Assert.Equal(_mockRoomReadDto, expected);
        }

        [Fact]
        public async Task GetAllRoomsByUser_ReturnsForbid()
        {
            var roomList = new Collection<RoomReadDto>() { _mockRoomReadDto };
            _mockRoomService
                .Setup(x => x.GetAllByUser(It.IsAny<string>()))
                .ReturnsAsync(roomList);

            var result = await _controller.GetAllRoomsByUser("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetAllRoomsByUser_ReturnsRoomReadDtoList()
        {
            var roomList = new Collection<RoomReadDto>() { _mockRoomReadDto };
            _mockRoomService
                .Setup(x => x.GetAllByUser(It.IsAny<string>()))
                .ReturnsAsync(roomList);

            var result = await _controller.GetAllRoomsByUser("UserId");
            var resultObject = result as OkObjectResult;
            var expected = resultObject?.Value as Collection<RoomReadDto>;

            Assert.Equal(roomList, expected);
        }

        [Fact]
        public async Task UpdateRoom_ReturnsNotFound()
        {
            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((RoomReadDto) null);

            var result = await _controller.UpdateRoom(1, _mockRoomUpdateDto);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task UpdateRoom_ReturnsForbid()
        {
            var mockRoomReadDto = _mockRoomReadDto;
            mockRoomReadDto.UserId = "FakeUserId";

            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(mockRoomReadDto);

            var result = await _controller.UpdateRoom(1, _mockRoomUpdateDto);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task UpdateRoom_ReturnsNoContent()
        {
            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoomReadDto);

            var result = await _controller.UpdateRoom(1, _mockRoomUpdateDto);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsNotFound()
        {
            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((RoomReadDto)null);

            var result = await _controller.DeleteRoom(1);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsForbid()
        {
            var mockRoomReadDto = _mockRoomReadDto;
            mockRoomReadDto.UserId = "FakeUserId";

            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(mockRoomReadDto);

            var result = await _controller.DeleteRoom(1);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsNoContent()
        {
            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoomReadDto);
            _mockRoomService
                .Setup(x => x.Delete(It.IsAny<int>()))
                .ReturnsAsync(true);

            var result = await _controller.DeleteRoom(1);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsBadRequest()
        {
            _mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoomReadDto);
            _mockRoomService
                .Setup(x => x.Delete(It.IsAny<int>()))
                .ReturnsAsync(false);

            var result = await _controller.DeleteRoom(1);

            Assert.IsType<BadRequestResult>(result);
        }
    }
}
