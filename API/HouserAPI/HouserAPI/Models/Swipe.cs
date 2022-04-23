using HouserAPI.Enums;

namespace HouserAPI.Models
{
    public class Swipe : Entity
    {
        public SwipeType SwipeType { get; set; }
        public FilterType FilterType { get; set; }
        public User Swiper { get; set; }
        public string SwiperId { get; set; }
        public User UserTarget { get; set; }
        public string UserTargetId { get; set; }
        public Room Room { get; set; }
        public int? RoomId { get; set; }
    }
}
