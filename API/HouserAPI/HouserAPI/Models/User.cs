using System;
using System.Collections.Generic;
using HouserAPI.Enums;
using Microsoft.AspNetCore.Identity;

namespace HouserAPI.Models
{
    public class User : IdentityUser
    {
        public string Salt { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string City { get; set; }
        public virtual ICollection<Image> Images { get; set; }
        public DateTime BirthDate { get; set; }
        public int Sex { get; set; }
        public int AnimalCount { get; set; }
        public bool IsStudying { get; set; }
        public bool IsWorking { get; set; }
        public bool IsSmoking { get; set; }
        public SleepType SleepType { get; set; }
        public int GuestCount { get; set; }
        public int PartyCount { get; set; }
    }
}
