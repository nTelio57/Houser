using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.DTOs.Filter;
using HouserAPI.DTOs.Room;
using HouserAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace HouserAPI_Test
{
    public class FilterControllerTest
    {
        private readonly Mock<IFilterService> _mockFilterService;
        private readonly FilterController _controller;
        public FilterControllerTest()
        {
            _mockFilterService = new Mock<IFilterService>();

            _controller = GetFilterController(_mockFilterService.Object);
        }

        private static ClaimsPrincipal MockUser()
        {
            return new(new ClaimsIdentity(new Claim[]
            {
                new (CustomClaims.UserId, "UserId"),
            }, "mock"));
        }

        private static FilterController GetFilterController(IFilterService filterService)
        {
            return new(filterService)
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

        private readonly FilterReadDto _mockFilterReadDto = new()
        {
            Id = 1,
            UserId = "UserId",
        };

        private readonly RoomFilterReadDto _mockRoomFilterReadDto = new()
        {
            Id = 1,
            UserId = "UserId",
        };

        private readonly RoomFilterCreateDto _mockRoomFilterCreateDto = new()
        {
        };

        private readonly UserFilterReadDto _mockUserFilterReadDto = new()
        {
            Id = 1,
            UserId = "UserId",
        };

        private readonly UserFilterCreateDto _mockUserFilterCreateDto = new()
        {
        };

        [Fact]
        public async Task GetFilterByUserId_ReturnsForbid()
        {
            var result = await _controller.GetFilterByUserId("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetFilterByUserId_ReturnsNotFound()
        {
            _mockFilterService
                .Setup(x => x.GetByUserId(It.IsAny<string>()))
                .ReturnsAsync((FilterReadDto) null);

            var result = await _controller.GetFilterByUserId("UserId");

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task GetFilterByUserId_ReturnsOk()
        {
            _mockFilterService
                .Setup(x => x.GetByUserId(It.IsAny<string>()))
                .ReturnsAsync(_mockFilterReadDto);

            var result = await _controller.GetFilterByUserId("UserId");
            var resultObject = result as OkObjectResult;
            var expected = resultObject?.Value as FilterReadDto;

            Assert.Equal(_mockFilterReadDto, expected);
        }

        [Fact]
        public async Task CreateRoomFilter_ReturnsBadRequest()
        {
            var result = await _controller.CreateRoomFilter(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateRoomFilter_ReturnsOk()
        {
            _mockFilterService
                .Setup(x => x.Create(It.IsAny<FilterCreateDto>(), It.IsAny<string>()))
                .ReturnsAsync(_mockFilterReadDto);

            var result = await _controller.CreateRoomFilter(_mockRoomFilterCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var expected = resultObject?.Value as FilterReadDto;

            Assert.Equal(_mockFilterReadDto, expected);
        }

        [Fact]
        public async Task CreateRoomFilter_ReturnsBadRequestCatch()
        {
            _mockFilterService
                .Setup(x => x.Create(It.IsAny<FilterCreateDto>(), It.IsAny<string>()))
                .ThrowsAsync(new ArgumentNullException());

            var result = await _controller.CreateRoomFilter(_mockRoomFilterCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateUserFilter_ReturnsBadRequest()
        {
            var result = await _controller.CreateUserFilter(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateUserFilter_ReturnsOk()
        {
            _mockFilterService
                .Setup(x => x.Create(It.IsAny<FilterCreateDto>(), It.IsAny<string>()))
                .ReturnsAsync(_mockFilterReadDto);

            var result = await _controller.CreateUserFilter(_mockUserFilterCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var expected = resultObject?.Value as FilterReadDto;

            Assert.Equal(_mockFilterReadDto, expected);
        }

        [Fact]
        public async Task CreateUserFilter_ReturnsBadRequestCatch()
        {
            _mockFilterService
                .Setup(x => x.Create(It.IsAny<FilterCreateDto>(), It.IsAny<string>()))
                .ThrowsAsync(new ArgumentNullException());

            var result = await _controller.CreateUserFilter(_mockUserFilterCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }
    }
}
