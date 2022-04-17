using HouserAPI.Enums;

namespace HouserAPI.Models
{
    public class UserFilter : Filter
    {
        public int AgeFrom { get; set; }
        public int AgeTo { get; set; }
        public int Sex { get; set; }
        public int AnimalCount { get; set; }
        public bool IsStudying { get; set; }
        public bool IsWorking { get; set; }
        public bool IsSmoking { get; set; }
        public int GuestCount { get; set; }
        public int PartyCount { get; set; }
        public SleepType SleepType { get; set; }
    }
}
