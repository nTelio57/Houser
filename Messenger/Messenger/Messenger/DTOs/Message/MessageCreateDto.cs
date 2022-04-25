namespace Messenger.DTOs.Message
{
    public class MessageCreateDto
    {
        public string SenderId { get; set; }
        public int MatchId { get; set; }
        public string Content { get; set; }
    }
}
