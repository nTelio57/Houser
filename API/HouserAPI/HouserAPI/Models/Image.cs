namespace HouserAPI.Models
{
    public class Image : Entity
    {
        public string Path { get; set; }
        public string UserId { get; set; }
        public User User { get; set; }
    }
}
