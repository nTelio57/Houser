using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.DTOs.Match;
using HouserAPI.DTOs.Room;
using HouserAPI.DTOs.Swipe;
using HouserAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace HouserAPI_Test
{
    public class MatchControllerTest
    {
        private readonly Mock<IMatchService> _mockMatchService;
        private readonly MatchController _controller;
        public MatchControllerTest()
        {
            _mockMatchService = new Mock<IMatchService>();

            _controller = GetMatchController(_mockMatchService.Object);
        }

        private static ClaimsPrincipal MockUser()
        {
            return new(new ClaimsIdentity(new Claim[]
            {
                new (CustomClaims.UserId, "UserId"),
            }, "mock"));
        }

        private static MatchController GetMatchController(IMatchService matchService)
        {
            return new(matchService)
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

        private readonly SwipeCreateDto _mockSwipeCreateDto = new()
        {
            SwiperId = "UserId",
        };

        private readonly SwipeReadDto _mockSwipeReadDto = new()
        {
            Id = 1,
            SwiperId = "UserId",
        };

        private readonly MatchReadDto _mockMatchReadDto = new()
        {
            Id = 1,
            RoomOffererId = "UserId",
            UserOffererId = ""
        };

        [Fact]
        public async Task Swipe_ReturnsBadRequest()
        {
            var result = await _controller.Swipe(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task Swipe_ReturnsForbid()
        {
            var swipeCreateDto = _mockSwipeCreateDto;
            swipeCreateDto.SwiperId = "FakeUserId";

            var result = await _controller.Swipe(swipeCreateDto);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task Swipe_ReturnsOk()
        {
            _mockMatchService
                .Setup(x => x.Swipe(It.IsAny<SwipeCreateDto>()))
                .ReturnsAsync(_mockSwipeReadDto);

            var result = await _controller.Swipe(_mockSwipeCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var actual = resultObject?.Value as SwipeReadDto;

            Assert.Equal(_mockSwipeReadDto, actual);
        }

        [Fact]
        public async Task Swipe_ReturnsBadRequestCatch()
        {
            _mockMatchService
                .Setup(x => x.Swipe(It.IsAny<SwipeCreateDto>()))
                .ThrowsAsync(new ArgumentNullException());

            var result = await _controller.Swipe(_mockSwipeCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetAllMatchesByUser_ReturnsForbid()
        {
            var result = await _controller.GetAllMatchesByUser("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetAllMatchesByUser_ReturnsOk()
        {
            var matchList = new Collection<MatchReadDto>() { _mockMatchReadDto };
            _mockMatchService
                .Setup(x => x.GetAllByUser(It.IsAny<string>()))
                .ReturnsAsync(matchList);

            var result = await _controller.GetAllMatchesByUser("UserId");
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as Collection<MatchReadDto>;

            Assert.Equal(matchList, actual);
        }

        [Fact]
        public async Task DeleteMatch_ReturnsNotFound()
        {
            _mockMatchService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((MatchReadDto)null);

            var result = await _controller.DeleteMatch(1);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task DeleteMatch_ReturnsForbid()
        {
            var mockMatchReadDto = _mockMatchReadDto;
            mockMatchReadDto.RoomOffererId = "FakeUserId";
            mockMatchReadDto.UserOffererId = "FakeUserId";

            _mockMatchService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(mockMatchReadDto);

            var result = await _controller.DeleteMatch(1);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task DeleteMatch_ReturnsNoContent()
        {
            _mockMatchService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockMatchReadDto);
            _mockMatchService
                .Setup(x => x.Delete(It.IsAny<int>()))
                .ReturnsAsync(true);

            var result = await _controller.DeleteMatch(1);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteMatch_ReturnsBadRequest()
        {
            _mockMatchService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockMatchReadDto);
            _mockMatchService
                .Setup(x => x.Delete(It.IsAny<int>()))
                .ReturnsAsync(false);

            var result = await _controller.DeleteMatch(1);

            Assert.IsType<BadRequestResult>(result);
        }
    }
}
