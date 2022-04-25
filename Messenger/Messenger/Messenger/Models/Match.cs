namespace Messenger.Models
{
    public class Match : Entity
    {
        public User FirstUser { get; set; }
        public User SecondUser { get; set; }
        public int? RoomId { get; set; }

        public User GetReceiver(string senderId)
        {
            if (senderId == FirstUser.Id)
                return SecondUser;
            if (senderId == SecondUser.Id)
                return FirstUser;
            return null;
        }
    }
}
