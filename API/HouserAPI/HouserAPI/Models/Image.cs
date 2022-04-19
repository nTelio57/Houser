using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace HouserAPI.Models
{
    public class Image : Entity
    {
        public string Path { get; set; }
        public bool IsMain { get; set; }
        public string UserId { get; set; }
        public User User { get; set; }
        public int? RoomId { get; set; }
        [JsonIgnore]
        [IgnoreDataMember]
        public Room Room { get; set; }
    }
}
