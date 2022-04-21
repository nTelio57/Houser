namespace HouserAPI.DTOs.Image
{
    public class ImageReadDto
    {
        public int Id { get; set; }
        public string Path { get; set; }
        public bool IsMain { get; set; }
        public string UserId { get; set; }
        public int? RoomId { get; set; }
    }
}
