using HouserAPI.Enums;

namespace HouserAPI.DTOs.Match
{
    public class MatchCreateDto
    {
        public FilterType FilterType { get; set; }
        public string FirstUserId { get; set; }
        public string SecondUserId { get; set; }
        public int? RoomId { get; set; }
    }
}
