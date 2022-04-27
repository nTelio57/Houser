namespace Messenger.DTOs.Match
{
    public class MatchReadDto
    {
        public int Id { get; set; }
        public string UserOffererId { get; set; }
        public string RoomOffererId { get; set; }
        public int? RoomId { get; set; }
    }
}
