using System;
using HouserAPI.Enums;

namespace HouserAPI.DTOs.Offer
{
    public class OfferReadDto
    {
        public bool IsVisible { get; set; }
        public DateTime UploadDate { get; set; }
        public int Id { get; set; }
        public string Title { get; set; }
        public string City { get; set; }
        public string Address { get; set; }
        public float MonthlyPrice { get; set; }
        public bool UtilityBillsRequired { get; set; }
        public float Area { get; set; }
        public DateTime AvailableFrom { get; set; }
        public DateTime AvailableTo { get; set; }
        public int FreeRoomCount { get; set; }
        public int TotalRoomCount { get; set; }
        public int BedCount { get; set; }
        public BedType BedType { get; set; }
        //--------Rules-----
        public bool RuleSmoking { get; set; }
        public bool RuleAnimals { get; set; }
        //--------Accommodations----------
        public bool AccommodationTv { get; set; }
        public bool AccommodationWifi { get; set; }
        public bool AccommodationAc { get; set; }
        public bool AccommodationParking { get; set; }
        public bool AccommodationBalcony { get; set; }
        public bool AccommodationDisability { get; set; }

        public string UserId { get; set; }
    }
}
