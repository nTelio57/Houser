using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace HouserAPI.DTOs.User
{
    public class UserReadDto
    {
        public string Id { get; set; }
        public string Email { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public int Age { get; set; }
        public string City { get; set; }
    }
}
