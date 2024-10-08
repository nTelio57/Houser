﻿using HouserAPI.Enums;

namespace HouserAPI.Models
{
    public class Filter : Entity
    {
        public string UserId { get; set; }
        public int Elo { get; set; }
        public FilterType FilterType { get; set; }
    }
}
