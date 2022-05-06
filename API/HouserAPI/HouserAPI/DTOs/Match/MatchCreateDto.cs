using HouserAPI.Enums;

namespace HouserAPI.DTOs.Match
{
    public class MatchCreateDto
    {
        public string UserOffererId { get; set; }
        public string RoomOffererId { get; set; }
        public int? RoomId { get; set; }
    }
}
