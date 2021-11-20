using System.Collections.Generic;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Models
{
    public class User : IdentityUser
    {
        public string Salt { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public int Age { get; set; }
        public string City { get; set; }
        public virtual ICollection<Image> Images { get; set; }
    }
}
