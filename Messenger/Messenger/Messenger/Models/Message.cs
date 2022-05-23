using System;

namespace Messenger.Models
{
    public class Message : Entity
    {
        public string SenderId { get; set; }
        public int MatchId { get; set; }
        public DateTime SendTime { get; set; }
        public string Content { get; set; }
    }
}
