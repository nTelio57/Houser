﻿using HouserAPI.Enums;

namespace HouserAPI.DTOs.Match
{
    public class MatchReadDto
    {
        public int Id { get; set; }
        public FilterType FilterType { get; set; }
        public string FirstUserId { get; set; }
        public string SecondUserId { get; set; }
        public int? RoomId { get; set; }
    }
}
