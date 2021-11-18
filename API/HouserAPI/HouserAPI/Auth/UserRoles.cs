using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace HouserAPI.Auth
{
    public class RolesAttribute : AuthorizeAttribute
    {
        public RolesAttribute(params string[] roles)
        {
            Roles = string.Join(",", roles);
        }
    }

    public static class UserRoles
    {
        public const string Admin = nameof(Admin);
        public const string Basic = nameof(Basic);

        public static readonly IReadOnlyCollection<string> All = new[] { Admin, Basic };
    }
}
