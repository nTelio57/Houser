using HouserAPI.Enums;

namespace HouserAPI.DTOs.Swipe
{
    public class SwipeReadDto
    {
        public int? Id { get; set; }
        public SwipeType? SwipeType { get; set; }
        public FilterType? FilterType { get; set; }
        public string SwiperId { get; set; }
        public string UserTargetId { get; set; }
        public int? RoomId { get; set; }
        public SwipeResult SwipeResult { get; set; }
    }
}
