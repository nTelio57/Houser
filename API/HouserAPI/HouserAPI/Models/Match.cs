using HouserAPI.Enums;

namespace HouserAPI.Models
{
    public class Match : Entity
    {
        public FilterType FilterType { get; set; }
        public User UserOfferer { get; set; }
        public string UserOffererId { get; set; }
        public User RoomOfferer { get; set; }
        public string RoomOffererId { get; set; }
        public Room Room { get; set; }
        public int? RoomId { get; set; }
    }
}
