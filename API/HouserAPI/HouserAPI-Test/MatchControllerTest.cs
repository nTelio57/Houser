using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.Data;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Match;
using HouserAPI.DTOs.Room;
using HouserAPI.DTOs.Swipe;
using HouserAPI.Enums;
using HouserAPI.Models;
using HouserAPI.Profiles;
using HouserAPI.Services;
using HouserAPI.Utilities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using Newtonsoft.Json;
using Xunit;
using Match = HouserAPI.Models.Match;

namespace HouserAPI_Test
{
    public class MatchControllerTest
    {
        private readonly Mock<IMatchService> _mockMatchService;
        private readonly IMapper _mapper;
        private readonly IMatchService _matchService;
        private readonly Mock<MatchRepository> _mockMatchRepository;
        private readonly Mock<SwipeRepository> _mockSwipeRepository;
        private readonly Mock<UserManager<User>> _mockUserManager;
        public MatchControllerTest()
        {
            var mapperConfig = new ConfigurationProfile().Configure();
            _mapper = mapperConfig.CreateMapper();
            _mockUserManager = MockUtilities.MockUserManager<User>();

            var options = new DbContextOptionsBuilder<DatabaseContext>()
                .UseInMemoryDatabase("IN_MEMORY_DATABASE")
                .Options;
            var mockDatabaseContext = new Mock<DatabaseContext>(options);

            _mockSwipeRepository = new Mock<SwipeRepository>(mockDatabaseContext.Object);
            _mockMatchRepository = new Mock<MatchRepository>(mockDatabaseContext.Object);
            var mockRoomRepository = new Mock<RoomRepository>(mockDatabaseContext.Object);

            _mockMatchService = new Mock<IMatchService>();
            _matchService = new MatchService(_mapper, _mockSwipeRepository.Object, _mockMatchRepository.Object, mockRoomRepository.Object, _mockUserManager.Object);
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

        private readonly User _mockUser = new()
        {
            Id = "UserId",
            Filter = null,
            AnimalCount = 0,
            GuestCount = 0,
            IsSmoking = false,
            IsStudying = false,
            IsWorking = false,
            PartyCount = 0,
            Sex = 0,
            SleepType = SleepType.Evening,
            BirthDate = new DateTime(2022, 01, 01),
            City = "Kaunas",
            Name = "Name",
            Surname = "Surname",
            Elo = 0,
            Salt = "Salt",
        };

        private readonly Swipe _mockSwipe = new()
        {
            Id = 0,
            SwiperId = "UserId",
            FilterType = FilterType.Room,
            SwipeType = SwipeType.Dislike,
            RoomId = 0,
            UserTargetId = "UserId1",
            Swiper = null,
            UserTarget = null,
            Room = null
        };

        private readonly SwipeCreateDto _mockSwipeCreateDto = new()
        {
            SwiperId = "UserId",
            FilterType = FilterType.Room,
            SwipeType = SwipeType.Dislike,
            RoomId = 0,
            UserTargetId = "UserId1"
        };

        private readonly SwipeReadDto _mockSwipeReadDto = new()
        {
            Id = 0,
            SwiperId = "UserId",
            FilterType = FilterType.Room,
            SwipeType = SwipeType.Dislike,
            RoomId = 0,
            SwipeResult = SwipeResult.Swiped,
            UserTargetId = "UserId1"
        };

        private readonly Match _mockMatch = new()
        {
            Id = 0,
            RoomOffererId = "UserId",
            UserOffererId = "",
            RoomId = 0,
            RoomOfferer = null,
            UserOfferer = null,
            Room = null
        };

        private readonly MatchReadDto _mockMatchReadDto = new()
        {
            Id = 0,
            RoomOffererId = "UserId",
            UserOffererId = ""
        };

        [Fact]
        public async Task Swipe_ReturnsBadRequest()
        {
            var controller = GetMatchController(_matchService);

            var result = await controller.Swipe(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task Swipe_ReturnsForbid()
        {
            var swipeCreateDto = _mockSwipeCreateDto;
            swipeCreateDto.SwiperId = "FakeUserId";

            var controller = GetMatchController(_matchService);

            var result = await controller.Swipe(swipeCreateDto);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task Swipe_ReturnsOk()
        {
            _mockUserManager
                .Setup(x => x.FindByIdAsync(It.IsAny<string>()))
                .ReturnsAsync(_mockUser);
            _mockSwipeRepository
                .Setup(x => x.Create(It.IsAny<Swipe>()))
                .Returns(Task.FromResult(_mockSwipe));

            var controller = GetMatchController(_matchService);

            var result = await controller.Swipe(_mockSwipeCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var actual = resultObject?.Value as SwipeReadDto;
            
            Assert.Equal(JsonConvert.SerializeObject(_mockSwipeReadDto), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task Swipe_ReturnsBadRequestCatch()
        {
            _mockMatchService
                .Setup(x => x.Swipe(It.IsAny<SwipeCreateDto>()))
                .ThrowsAsync(new ArgumentNullException());

            var controller = GetMatchController(_matchService);

            var result = await controller.Swipe(_mockSwipeCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetAllMatchesByUser_ReturnsForbid()
        {
            var controller = GetMatchController(_matchService);

            var result = await controller.GetAllMatchesByUser("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetAllMatchesByUser_ReturnsOk()
        {
            var matchList = new Collection<Match>() { _mockMatch };
            _mockMatchRepository
                .Setup(x => x.GetAllByUser(It.IsAny<string>()))
                .ReturnsAsync(matchList);

            var controller = GetMatchController(_matchService);

            var expected = _mapper.Map<IEnumerable<MatchReadDto>>(matchList);
            var result = await controller.GetAllMatchesByUser("UserId");
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as IEnumerable<MatchReadDto>;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task DeleteMatch_ReturnsNotFound()
        {
            var controller = GetMatchController(_matchService);

            var result = await controller.DeleteMatch(1);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task DeleteMatch_ReturnsForbid()
        {
            var mockMatch = _mockMatch;
            mockMatch.RoomOffererId = "FakeUserId";
            mockMatch.UserOffererId = "FakeUserId";
            
            _mockMatchRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(mockMatch);

            var controller = GetMatchController(_matchService);

            var result = await controller.DeleteMatch(1);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task DeleteMatch_ReturnsNoContent()
        {
            _mockMatchRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockMatch);
            _mockMatchRepository
                .Setup(x => x.Delete(It.IsAny<Match>()))
                .Returns(Task.FromResult(true));
            _mockMatchRepository
                .Setup(x => x.SaveChanges())
                .Returns(Task.FromResult(true));

            var controller = GetMatchController(_matchService);

            var result = await controller.DeleteMatch(1);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteMatch_ReturnsBadRequest()
        {
            _mockMatchRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockMatch);
            _mockMatchRepository
                .Setup(x => x.Delete(It.IsAny<Match>()))
                .Returns(Task.FromResult(false));
            _mockMatchRepository
                .Setup(x => x.SaveChanges())
                .Returns(Task.FromResult(false));


            var controller = GetMatchController(_matchService);

            var result = await controller.DeleteMatch(1);

            Assert.IsType<BadRequestResult>(result);
        }
    }
}
