using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace HouserAPI.Models
{
    public class Image : Entity
    {
        public string Path { get; set; }
        public string UserId { get; set; }
        public User User { get; set; }
        public int? OfferId { get; set; }
        [JsonIgnore]
        [IgnoreDataMember]
        public Offer Offer { get; set; }
    }
}
