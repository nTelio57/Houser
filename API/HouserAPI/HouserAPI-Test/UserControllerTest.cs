using System;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using HouserAPI.Auth;
using HouserAPI.Controllers;
using HouserAPI.DTOs.User;
using HouserAPI.Enums;
using HouserAPI.Models;
using HouserAPI.Profiles;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Newtonsoft.Json;
using Xunit;

namespace HouserAPI_Test
{
    public class UserControllerTest
    {
        private readonly IMapper _mapper;
        private readonly Mock<UserManager<User>> _mockUserManager;
        public UserControllerTest()
        {
            var mapperConfig = new ConfigurationProfile().Configure();
            _mapper = mapperConfig.CreateMapper();
            _mockUserManager = MockUtilities.MockUserManager<User>();
        }

        private static ClaimsPrincipal MockUser()
        {
            return new(new ClaimsIdentity(new Claim[]
            {
                new (CustomClaims.UserId, "UserId"),
            }, "mock"));
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

        private readonly UserUpdateDto _mockUserUpdateDto = new()
        {
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
        };

        private static UserController GetUserController(UserManager<User> userManager, IMapper mapper)
        {
            return new(userManager, mapper)
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

        [Fact]
        public async Task GetUserById_ReturnsForbid()
        {
            var controller = GetUserController(_mockUserManager.Object, _mapper);

            var result = await controller.GetUserById("FakeUserId");

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task GetUserById_ReturnsNotFound()
        {
            var controller = GetUserController(_mockUserManager.Object, _mapper);

            var result = await controller.GetUserById("UserId");

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task GetUserById_ReturnsOk()
        {
            _mockUserManager
                .Setup(x => x.FindByIdAsync(It.IsAny<string>()))
                .ReturnsAsync(_mockUser);

            var controller = GetUserController(_mockUserManager.Object, _mapper);

            var expected = _mapper.Map<UserReadDto>(_mockUser);
            var result = await controller.GetUserById("UserId");
            var resultObject = result as OkObjectResult;
            var actual = resultObject?.Value as UserReadDto;

            Assert.Equal(JsonConvert.SerializeObject(expected), JsonConvert.SerializeObject(actual));
        }

        [Fact]
        public async Task UpdateUser_ReturnsForbid()
        {
            var controller = GetUserController(_mockUserManager.Object, _mapper);
            
            var result = await controller.UpdateUser("FakeUserId", _mockUserUpdateDto);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task UpdateUser_ReturnsNotFound()
        {
            var controller = GetUserController(_mockUserManager.Object, _mapper);

            var result = await controller.UpdateUser("UserId", _mockUserUpdateDto);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task UpdateUser_ReturnsNoContent()
        {
            _mockUserManager
                .Setup(x => x.FindByIdAsync(It.IsAny<string>()))
                .ReturnsAsync(_mockUser);

            var controller = GetUserController(_mockUserManager.Object, _mapper);
            
            var result = await controller.UpdateUser("UserId", _mockUserUpdateDto);

            Assert.IsType<NoContentResult>(result);
        }

        [Fact]
        public async Task UpdateVisibility_ReturnsForbid()
        {
            var controller = GetUserController(_mockUserManager.Object, _mapper);

            var result = await controller.UpdateVisibility("FakeUserId", 0);

            Assert.IsType<ForbidResult>(result);
        }

        [Fact]
        public async Task UpdateVisibility_ReturnsNotFound()
        {
            var controller = GetUserController(_mockUserManager.Object, _mapper);

            var result = await controller.UpdateVisibility("UserId", 0);

            Assert.IsType<NotFoundResult>(result);
        }

        [Fact]
        public async Task UpdateVisibility_ReturnsNoContent()
        {
            _mockUserManager
                .Setup(x => x.FindByIdAsync(It.IsAny<string>()))
                .ReturnsAsync(_mockUser);

            var controller = GetUserController(_mockUserManager.Object, _mapper);

            var result = await controller.UpdateVisibility("UserId", 0);

            Assert.IsType<NoContentResult>(result);
        }
    }
}
