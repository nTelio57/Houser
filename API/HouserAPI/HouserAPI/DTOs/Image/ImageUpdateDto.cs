namespace HouserAPI.DTOs.Image
{
    public class ImageUpdateDto
    {
        public bool IsMain { get; set; }
        public string UserId { get; set; }
        public int? OfferId { get; set; }
    }
}
