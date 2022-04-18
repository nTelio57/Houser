using HouserAPI.Enums;

namespace HouserAPI.DTOs.Filter
{
    public class FilterReadDto
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public FilterType FilterType { get; set; }
    }
}
