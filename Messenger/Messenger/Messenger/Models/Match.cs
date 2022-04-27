namespace Messenger.Models
{
    public class Match : Entity
    {
        public User UserOfferer { get; set; }
        public string UserOffererId { get; set; }
        public User RoomOfferer { get; set; }
        public string RoomOffererId { get; set; }
        public int? RoomId { get; set; }

        public string GetReceiverId(string senderId)
        {
            if (senderId == UserOffererId)
                return RoomOffererId;
            if (senderId == RoomOffererId)
                return UserOffererId;
            return null;
        }
    }
}
