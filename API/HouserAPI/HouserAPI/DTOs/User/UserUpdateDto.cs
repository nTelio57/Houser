﻿using System;
using HouserAPI.Enums;

namespace HouserAPI.DTOs.User
{
    public class UserUpdateDto
    {
        public bool IsVisible { get; set; }
        public string Name { get; set; }
        public string City { get; set; }
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
