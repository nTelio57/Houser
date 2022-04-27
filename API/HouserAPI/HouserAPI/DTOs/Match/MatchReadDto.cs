using HouserAPI.DTOs.Room;
using HouserAPI.DTOs.User;
using HouserAPI.Enums;

namespace HouserAPI.DTOs.Match
{
    public class MatchReadDto
    {
        public int Id { get; set; }
        public FilterType FilterType { get; set; }
        public string UserOffererId { get; set; }
        public UserReadDto UserOfferer { get; set; }
        public string RoomOffererId { get; set; }
        public UserReadDto RoomOfferer { get; set; }
        public RoomReadDto Room { get; set; }
        public int? RoomId { get; set; }
    }
}
