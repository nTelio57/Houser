using System;
using System.Collections.ObjectModel;
using System.Security.Claims;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.DTOs.Room;
using HouserAPI.DTOs.User;
using HouserAPI.Models;
using HouserAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace HouserAPI_Test
{
    public class RecommendationControllerTest
    {
        private readonly Mock<IRecommendationService> _mockRecommendationService;
        private readonly RecommendationController _controller;
        public RecommendationControllerTest()
        {
            _mockRecommendationService = new Mock<IRecommendationService>();

            _controller = GetRecommendationController(_mockRecommendationService.Object);
        }

        private static ClaimsPrincipal MockUser()
        {
            return new(new ClaimsIdentity(new Claim[]
            {
                new (CustomClaims.UserId, "UserId"),
            }, "mock"));
        }

        private static RecommendationController GetRecommendationController(IRecommendationService recommendationService)
        {
            return new(recommendationService)
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

        private readonly RoomFilter _mockRoomFilter = new()
        {
            Id = 0,
            UserId = "UserId",
        };

        private readonly UserFilter _mockUserFilter = new()
        {
            Id = 0,
            UserId = "UserId",
        };

        private readonly RoomReadDto _mockRoomReadDto = new()
        {
            Id = 0
        };

        private readonly UserReadDto _mockUserReadDto = new()
        {
            Id = "UserId2"
        };

        [Fact]
        public async Task GetRoomRecommendationByFilter_ReturnsForbid()
        {
            var roomFilter = _mockRoomFilter;
            roomFilter.UserId = "FakeUserId";

            var result = await _controller.GetRoomRecommendationByFilter(1, 1, _mockRoomFilter);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetRoomRecommendationByFilter_ReturnsOk()
        {
            var roomList = new Collection<RoomReadDto>() { _mockRoomReadDto };
            _mockRecommendationService
                .Setup(x => x.GetRoomRecommendationByFilter(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<RoomFilter>(), It.IsAny<string>()))
                .ReturnsAsync(roomList);

            var result = await _controller.GetRoomRecommendationByFilter(1, 1, _mockRoomFilter);
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as Collection<RoomReadDto>;

            Assert.Equal(roomList, actual);
        }

        [Fact]
        public async Task GetRoomRecommendationByFilter_ReturnsBadRequestCatch()
        {
            _mockRecommendationService
                .Setup(x => x.GetRoomRecommendationByFilter(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<RoomFilter>(), It.IsAny<string>()))
                .ThrowsAsync(new ArgumentNullException());

            var result = await _controller.GetRoomRecommendationByFilter(1, 1, _mockRoomFilter);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetUserRecommendationByFilter_ReturnsForbid()
        {
            var roomFilter = _mockUserFilter;
            roomFilter.UserId = "FakeUserId";

            var result = await _controller.GetUserRecommendationByFilter(1, 1, _mockUserFilter);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetUserRecommendationByFilter_ReturnsOk()
        {
            var userList = new Collection<UserReadDto>() { _mockUserReadDto };
            _mockRecommendationService
                .Setup(x => x.GetUserRecommendationByFilter(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<UserFilter>(), It.IsAny<string>()))
                .ReturnsAsync(userList);

            var result = await _controller.GetUserRecommendationByFilter(1, 1, _mockUserFilter);
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as Collection<UserReadDto>;

            Assert.Equal(userList, actual);
        }

        [Fact]
        public async Task GetUserRecommendationByFilter_ReturnsBadRequestCatch()
        {
            _mockRecommendationService
                .Setup(x => x.GetUserRecommendationByFilter(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<UserFilter>(), It.IsAny<string>()))
                .ThrowsAsync(new ArgumentNullException());

            var result = await _controller.GetUserRecommendationByFilter(1, 1, _mockUserFilter);

            Assert.IsType<BadRequestObjectResult>(result);
        }
    }
}
