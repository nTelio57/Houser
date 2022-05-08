using System.Collections.Generic;
using Microsoft.AspNetCore.Identity;
using Moq;

namespace HouserAPI_Test
{
    public static class MockUtilities
    {
        public static Mock<UserManager<TUser>> MockUserManager<TUser>() where TUser : class
        {
            var userValidators = new List<IUserValidator<TUser>>();
            var passwordValidators = new List<IPasswordValidator<TUser>>();

            var store = new Mock<IUserStore<TUser>>();
            userValidators.Add(new UserValidator<TUser>());
            passwordValidators.Add(new PasswordValidator<TUser>());
            var mgr = new Mock<UserManager<TUser>>(store.Object, null, null, userValidators, passwordValidators, null, null, null, null);
            return mgr;
        }
    }
}
