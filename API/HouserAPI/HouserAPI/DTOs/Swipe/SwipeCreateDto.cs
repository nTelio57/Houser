using System.ComponentModel.DataAnnotations;
using HouserAPI.Enums;

namespace HouserAPI.DTOs.Swipe
{
    public class SwipeCreateDto
    {
        [Required]
        public SwipeType SwipeType { get; set; }
        [Required]
        public FilterType FilterType{ get; set; }
        [Required]
        public string SwiperId { get; set; }
        [Required]
        public string UserTargetId { get; set; }
        public int? RoomId { get; set; }
    }
}
