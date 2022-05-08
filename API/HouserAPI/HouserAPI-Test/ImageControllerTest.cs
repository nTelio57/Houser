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
    public class ImageControllerTest
    {
        private readonly IMapper _mapper;
        private readonly IRoomService _roomService;
        private readonly IImageService _imageService;
        private readonly Mock<RoomRepository> _mockRoomRepository;
        private readonly Mock<ImageRepository> _mockImageRepository;
        public ImageControllerTest()
        {
            var mapperConfig = new ConfigurationProfile().Configure();
            _mapper = mapperConfig.CreateMapper();
            var mockUserManager = MockUtilities.MockUserManager<User>();

            var options = new DbContextOptionsBuilder<DatabaseContext>()
                .UseInMemoryDatabase("IN_MEMORY_DATABASE")
                .Options;
            var mockDatabaseContext = new Mock<DatabaseContext>(options);

            _mockRoomRepository = new Mock<RoomRepository>(mockDatabaseContext.Object);
            _mockImageRepository = new Mock<ImageRepository>(mockDatabaseContext.Object);
            var mockSwipeRepository = new Mock<SwipeRepository>(mockDatabaseContext.Object);
            var mockMatchRepository = new Mock<MatchRepository>(mockDatabaseContext.Object);

            IMatchService matchService = new MatchService(_mapper, mockSwipeRepository.Object, mockMatchRepository.Object, _mockRoomRepository.Object, mockUserManager.Object);
            _roomService = new RoomService(_mockRoomRepository.Object, _mapper, matchService);
            _imageService = new ImageService(_mockImageRepository.Object, _roomService, _mapper, null);
        }

        private static ImageController GetImageController(IImageService imageService, IRoomService roomService)
        {
            return new(imageService, roomService)
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

        private static ClaimsPrincipal MockUser()
        {
            return new(new ClaimsIdentity(new Claim[]
            {
                new (CustomClaims.UserId, "UserId"),
            }, "mock"));
        }

        private readonly Image _mockImage = new()
        {
            Id = 0,
            IsMain = true,
            Path = "Path",
            RoomId = null,
            UserId = "UserId",
            Room = null,
            User = null
        };

        private readonly ImageUpdateDto _mockImageUpdateDto = new()
        {
            IsMain = true,
            RoomId = null,
            UserId = "UserId",
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

        [Fact]
        public async Task GetAllImagesByUser_ReturnsForbid()
        {
            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.GetAllImagesByUser("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetAllImagesByUser_ReturnsOk()
        {
            var imageList = new Collection<Image>() { _mockImage };
            _mockImageRepository
                .Setup(x => x.GetAllByUser(It.IsAny<string>()))
                .ReturnsAsync(imageList);

            var controller = GetImageController(_imageService, _roomService);
            
            var expected = _mapper.Map<IEnumerable<ImageReadDto>>(imageList);
            var result = await controller.GetAllImagesByUser("UserId");
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as IEnumerable<ImageReadDto>;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task GetImageById_ReturnsNotFound()
        {
            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((Image)null);

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.GetImageById(0);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task GetImageById_ReturnsFileNotFoundCatch()
        {
            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockImage);
            _mockImageRepository
                .Setup(x => x.Delete(It.IsAny<Image>()))
                .Returns(Task.FromResult(true));

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.GetImageById(0);

            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public async Task UpdateImage_ReturnsNotFound()
        {
            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((Image)null);

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.UpdateImage(0, _mockImageUpdateDto);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task UpdateImage_ReturnsForbid()
        {
            var mockImage = _mockImage;
            mockImage.UserId = "FakeUserId";

            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(mockImage);

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.UpdateImage(0, _mockImageUpdateDto);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task UpdateImage_ReturnsNoContent()
        {
            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockImage);

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.UpdateImage(0, _mockImageUpdateDto);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task DeleteImage_ReturnsNotFound()
        {
            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync((Image)null);

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.DeleteImage(0);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task DeleteImage_ReturnsForbid()
        {
            var mockImage = _mockImage;
            mockImage.UserId = "FakeUserId";

            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(mockImage);

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.DeleteImage(0);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task DeleteImage_ReturnsNoContent()
        {
            _mockImageRepository
                .Setup(x => x.GetById(It.IsAny<int>()))
                .ReturnsAsync(_mockImage);

            var controller = GetImageController(_imageService, _roomService);

            var result = await controller.DeleteImage(0);

            Assert.IsType<NoContentResult>(result);
        }
    }
}
