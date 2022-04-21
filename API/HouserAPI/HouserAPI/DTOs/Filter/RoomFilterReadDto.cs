using System;

namespace HouserAPI.DTOs.Filter
{
    public class RoomFilterReadDto : FilterReadDto
    {
    public float? Area { get; set; }
    public float? MonthlyPrice { get; set; }
    public string City { get; set; }
    public DateTime? AvailableFrom { get; set; }
    public DateTime? AvailableTo { get; set; }
    public int? FreeRoomCount { get; set; }

    public int? BedCount { get; set; }

    //--------Rules-----
    public bool? RuleSmoking { get; set; }

    public bool? RuleAnimals { get; set; }

    //--------Accommodations----------
    public bool? AccommodationTv { get; set; }
    public bool? AccommodationWifi { get; set; }
    public bool? AccommodationAc { get; set; }
    public bool? AccommodationParking { get; set; }
    public bool? AccommodationBalcony { get; set; }
    public bool? AccommodationDisability { get; set; }
    }
}
