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
using HouserAPI.DTOs.Image;
using HouserAPI.DTOs.Room;
using HouserAPI.Models;
using HouserAPI.Profiles;
using HouserAPI.Services;
using HouserAPI.Utilities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using Newtonsoft.Json;
using Xunit;

namespace HouserAPI_Test
{
    public class RoomControllerTest
    {
        private readonly IRoomService _roomService;
        private readonly IImageService _imageService;
        private readonly Mock<RoomRepository> _mockRoomRepository;
        private readonly IMapper _mapper;
        public RoomControllerTest()
        {
            var mapperConfig = new ConfigurationProfile().Configure();
            _mapper = mapperConfig.CreateMapper();
            var mockUserManager = MockUtilities.MockUserManager<User>();

            var options = new DbContextOptionsBuilder<DatabaseContext>()
                .UseInMemoryDatabase("IN_MEMORY_DATABASE")
                .Options;
            var mockDatabaseContext = new Mock<DatabaseContext>(options);

            _mockRoomRepository = new Mock<RoomRepository>(mockDatabaseContext.Object);
            var mockSwipeRepository = new Mock<SwipeRepository>(mockDatabaseContext.Object);
            var mockMatchRepository = new Mock<MatchRepository>(mockDatabaseContext.Object);
            var mockImageRepository = new Mock<ImageRepository>(mockDatabaseContext.Object);
            
            IMatchService matchService = new MatchService(_mapper, mockSwipeRepository.Object, mockMatchRepository.Object, _mockRoomRepository.Object, mockUserManager.Object);
            _roomService = new RoomService(_mockRoomRepository.Object, _mapper, matchService);
            _imageService = new ImageService(mockImageRepository.Object, _roomService, _mapper, null);
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
            AccommodationAc = false,
            AccommodationBalcony = false,
            AccommodationDisability = false,
            AccommodationParking = false,
            AccommodationTv = false,
            AccommodationWifi = false,
            Area = 0
        };

        private readonly RoomReadDto _mockRoomReadDto = new()
        {
            Id = 0,
            IsVisible = true,
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
            IsVisible = true,
            Title = "Title",
            City = "City",
            Address = "Address",
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 02, 01),
            AccommodationAc = false,
            AccommodationBalcony = false,
            AccommodationDisability = false,
            AccommodationParking = false,
            AccommodationTv = false,
            AccommodationWifi = false,
            Area = 0
        };

        private readonly Room _mockRoom = new()
        {
            Id = 0,
            IsVisible = true,
            Title = "Title",
            City = "City",
            Address = "Address",
            AvailableFrom = new DateTime(2022, 01, 01),
            AvailableTo = new DateTime(2022, 02, 01),
            UserId = "UserId"
        };

        [Fact]
        public async Task CreateRoom_ReturnsBadRequest()
        {
            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.CreateRoom(null);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task CreateRoom_ReturnsRoomReadDto()
        {
            _mockRoomRepository
                .Setup(x => x.Create(It.IsAny<Room>()))
                .Returns(Task.FromResult(_mockRoom));

            var controller = GetRoomController(_roomService, _imageService);

            var expected = _mapper.Map<RoomReadDto>(_mockRoom);
            var result = await controller.CreateRoom(_mockCreateReadDto);
            var resultObject = result as CreatedAtActionResult;
            var actual = resultObject?.Value as RoomReadDto;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task CreateRoom_ReturnsBadRequestCatch()
        {
            var mockRoomService = new Mock<IRoomService>();
            mockRoomService
                .Setup(x => x.Create(It.IsAny<RoomCreateDto>()))
                .ThrowsAsync(new ArgumentNullException());

            var controller = GetRoomController(mockRoomService.Object, _imageService);

            var result = await controller.CreateRoom(_mockCreateReadDto);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task GetRoomById_ReturnsNotFound()
        {
            _mockRoomRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((Room) null);

            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.GetRoomById(1);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task GetRoomById_ReturnsRoomReadDto()
        {
            _mockRoomRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoom);

            var expected = _mapper.Map<RoomReadDto>(_mockRoom);

            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.GetRoomById(1);
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as RoomReadDto;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task GetAllRoomsByUser_ReturnsForbid()
        {
            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.GetAllRoomsByUser("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetAllRoomsByUser_ReturnsRoomReadDtoList()
        {
            var roomList = new Collection<Room>() { _mockRoom };
            _mockRoomRepository
                .Setup(x => x.GetAllByUser(It.IsAny<string>()))
                .ReturnsAsync(roomList);
            var expected = _mapper.Map<IEnumerable<RoomReadDto>>(roomList);

            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.GetAllRoomsByUser("UserId");
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as IEnumerable<RoomReadDto>;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task UpdateRoom_ReturnsNotFound()
        {
            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.UpdateRoom(1, _mockRoomUpdateDto);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task UpdateRoom_ReturnsForbid()
        {
            var mockRoom = _mockRoom;
            mockRoom.UserId = "FakeUserId";
            
            _mockRoomRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoom);

            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.UpdateRoom(1, _mockRoomUpdateDto);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task UpdateRoom_ReturnsNoContent()
        {
            _mockRoomRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoom);

            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.UpdateRoom(1, _mockRoomUpdateDto);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsNotFound()
        {
            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.DeleteRoom(1);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsForbid()
        {
            var mockRoom = _mockRoom;
            mockRoom.UserId = "FakeUserId";
            
            _mockRoomRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoom);

            var controller = GetRoomController(_roomService, _imageService);

            var result = await controller.DeleteRoom(1);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsNoContent()
        {
            var mockRoomService = new Mock<IRoomService>();

            mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoomReadDto);
            mockRoomService
                .Setup(x => x.Delete(It.IsAny<int>()))
                .ReturnsAsync(true);

            var controller = GetRoomController(mockRoomService.Object, _imageService);

            var result = await controller.DeleteRoom(1);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteRoom_ReturnsBadRequest()
        {
            var mockRoomService = new Mock<IRoomService>();

            mockRoomService
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockRoomReadDto);
            mockRoomService
                .Setup(x => x.Delete(It.IsAny<int>()))
                .ReturnsAsync(false);

            var controller = GetRoomController(mockRoomService.Object, _imageService);

            var result = await controller.DeleteRoom(1);

            Assert.IsType<BadRequestResult>(result);
        }
    }
}
