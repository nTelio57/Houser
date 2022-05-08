using System;

namespace HouserAPI.Models
{
    public class Message : Entity
    {
        public User Sender { get; set; }
        public string SenderId { get; set; }
        public Match Match { get; set; }
        public int MatchId { get; set; }
        public DateTime SendTime { get; set; }
        public string Content { get; set; }
    }
}
