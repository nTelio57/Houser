using System;

namespace Messenger.DTOs.Message
{
    public class MessageReadDto
    {
        public int Id { get; set; }
        public string SenderId { get; set; }
        public int MatchId { get; set; }
        public DateTime SendTime { get; set; }
        public string Content { get; set; }
    }
}
