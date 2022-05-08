using System;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.Data;
using HouserAPI.Data.Repositories;
using HouserAPI.DTOs.Filter;
using HouserAPI.Enums;
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
    public class FilterControllerTest
    {
        private readonly Mock<FilterRepository> _mockFilterRepository;
        private readonly IFilterService _filterService;
        private readonly IMapper _mapper;

        public FilterControllerTest()
        {
            var mapperConfig = new ConfigurationProfile().Configure();
            _mapper = mapperConfig.CreateMapper();

            var options = new DbContextOptionsBuilder<DatabaseContext>()
                .UseInMemoryDatabase("IN_MEMORY_DATABASE")
                .Options;
            var mockDatabaseContext = new Mock<DatabaseContext>(options);

            _mockFilterRepository = new Mock<FilterRepository>(mockDatabaseContext.Object);
            _filterService = new FilterService(_mockFilterRepository.Object, _mapper);
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

        private readonly UserFilter _mockUserFilter = new()
        {
            Id = 0,
            Elo = 0,
            UserId = "UserId",
            FilterType = FilterType.User,
            AgeFrom = 0,
            AgeTo = 1,
            AnimalCount = 0,
            GuestCount = 0,
            IsSmoking = false,
            IsStudying = false,
            IsWorking = false,
            PartyCount = 0,
            Sex = 0,
            SleepType = SleepType.Evening
        };

        private readonly RoomFilter _mockRoomFilter = new()
        {
            Id = 0,
            Elo = 0,
            UserId = "UserId",
            FilterType = FilterType.Room,
            AccommodationAc = false,
            AccommodationBalcony = false,
            AccommodationDisability = false,
            AccommodationParking = false,
            AccommodationTv = false,
            AccommodationWifi = false,
            Area = 0,
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 01, 01),
            FreeRoomCount = 0,
            BedCount = 0,
            RuleAnimals = false,
            RuleSmoking = false,
            City = "Kaunas",
            MonthlyPrice = 0
        };

        private readonly RoomFilterReadDto _mockRoomFilterReadDto = new()
        {
            Id = 0,
            UserId = "UserId",
            FilterType = FilterType.Room,
            AccommodationAc = false,
            AccommodationBalcony = false,
            AccommodationDisability = false,
            AccommodationParking = false,
            AccommodationTv = false,
            AccommodationWifi = false,
            Area = 0,
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 01, 01),
            FreeRoomCount = 0,
            BedCount = 0,
            RuleAnimals = false,
            RuleSmoking = false,
            City = "Kaunas",
            MonthlyPrice = 0
        };

        private readonly RoomFilterCreateDto _mockRoomFilterCreateDto = new()
        {
            FilterType = FilterType.Room,
            AccommodationAc = false,
            AccommodationBalcony = false,
            AccommodationDisability = false,
            AccommodationParking = false,
            AccommodationTv = false,
            AccommodationWifi = false,
            Area = 0,
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 01, 01),
            FreeRoomCount = 0,
            BedCount = 0,
            RuleAnimals = false,
            RuleSmoking = false,
            City = "Kaunas",
            MonthlyPrice = 0
        };

        private readonly UserFilterReadDto _mockUserFilterReadDto = new()
        {
            Id = 0,
            UserId = "UserId",
            FilterType = FilterType.User,
            AgeFrom = 0,
            AgeTo = 1,
            AnimalCount = 0,
            GuestCount = 0,
            IsSmoking = false,
            IsStudying = false,
            IsWorking = false,
            PartyCount = 0,
            Sex = 0,
            SleepType = SleepType.Evening
        };

        private readonly UserFilterCreateDto _mockUserFilterCreateDto = new()
        {
            FilterType = FilterType.User,
            AgeFrom = 0,
            AgeTo = 1,
            AnimalCount = 0,
            GuestCount = 0,
            IsSmoking = false,
            IsStudying = false,
            IsWorking = false,
            PartyCount = 0,
            Sex = 0,
            SleepType = SleepType.Evening
        };

        [Fact]
        public async Task GetFilterByUserId_ReturnsForbid()
        {
            var controller = GetFilterController(_filterService);

            var result = await controller.GetFilterByUserId("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetFilterByUserId_ReturnsNotFound()
        {
            _mockFilterRepository
                .Setup(x => x.GetByUserId(It.IsAny<string>()))
                .ReturnsAsync((Filter) null);

            var controller = GetFilterController(_filterService);

            var result = await controller.GetFilterByUserId("UserId");

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task GetFilterByUserId_ReturnsOk()
        {
            _mockFilterRepository
                .Setup(x => x.GetByUserId(It.IsAny<string>()))
                .ReturnsAsync(_mockRoomFilter);

            var controller = GetFilterController(_filterService);

            var expected = _mapper.Map<RoomFilterReadDto>(_mockRoomFilter);
            var result = await controller.GetFilterByUserId("UserId");
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as RoomFilterReadDto;
            
            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task CreateRoomFilter_ReturnsBadRequest()
        {
            var controller = GetFilterController(_filterService);

            var result = await controller.CreateRoomFilter(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateRoomFilter_ReturnsOk()
        {
            _mockFilterRepository
                .Setup(x => x.Create(It.IsAny<RoomFilter>()))
                .Returns(Task.FromResult(_mockRoomFilter));

            var controller = GetFilterController(_filterService);
            
            var result = await controller.CreateRoomFilter(_mockRoomFilterCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var actual = resultObject?.Value as RoomFilterReadDto;

            Assert.Equal(JsonConvert.SerializeObject(_mockRoomFilterReadDto), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task CreateRoomFilter_ReturnsBadRequestCatch()
        {
            var filterTypeNull = new Filter()
            {
                FilterType = FilterType.None
            };

            _mockFilterRepository
                .Setup(x => x.GetByUserId(It.IsAny<string>()))
                .Returns(Task.FromResult(filterTypeNull));

            var controller = GetFilterController(_filterService);

            var result = await controller.CreateRoomFilter(_mockRoomFilterCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateUserFilter_ReturnsBadRequest()
        {
            var controller = GetFilterController(_filterService);

            var result = await controller.CreateUserFilter(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateUserFilter_ReturnsOk()
        {
            _mockFilterRepository
                .Setup(x => x.Create(It.IsAny<UserFilter>()))
                .Returns(Task.FromResult(_mockUserFilter));

            var controller = GetFilterController(_filterService);

            var result = await controller.CreateUserFilter(_mockUserFilterCreateDto);
            var resultObject = result as CreatedAtActionResult;
            var actual = resultObject?.Value as UserFilterReadDto;

            Assert.Equal(JsonConvert.SerializeObject(_mockUserFilterReadDto), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task CreateUserFilter_ReturnsBadRequestCatch()
        {
            var filterTypeNull = new Filter()
            {
                FilterType = FilterType.None
            };

            _mockFilterRepository
                .Setup(x => x.GetByUserId(It.IsAny<string>()))
                .Returns(Task.FromResult(filterTypeNull));

            var controller = GetFilterController(_filterService);

            var result = await controller.CreateUserFilter(_mockUserFilterCreateDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }
    }
}
