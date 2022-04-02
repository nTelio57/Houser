using System;
using System.ComponentModel.DataAnnotations;
using HouserAPI.Enums;

namespace HouserAPI.DTOs.User
{
    public class UserCreateDto
    {
        [Required]
        public string Email { get; set; }
        [Required]
        public string Password { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string City{ get; set; }
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
