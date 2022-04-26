namespace Messenger.Models
{
    public class Match : Entity
    {
        public User FirstUser { get; set; }
        public string FirstUserId { get; set; }
        public User SecondUser { get; set; }
        public string SecondUserId { get; set; }
        public int? RoomId { get; set; }

        public string GetReceiverId(string senderId)
        {
            if (senderId == FirstUserId)
                return SecondUserId;
            if (senderId == SecondUserId)
                return FirstUserId;
            return null;
        }
    }
}
