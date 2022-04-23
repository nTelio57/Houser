using HouserAPI.Enums;

namespace HouserAPI.Models
{
    public class Match : Entity
    {
        public FilterType FilterType { get; set; }
        public User FirstUser { get; set; }
        public string FirstUserId { get; set; }
        public User SecondUser { get; set; }
        public string SecondUserId { get; set; }
        public Room Room { get; set; }
        public int? RoomId { get; set; }
    }
}
