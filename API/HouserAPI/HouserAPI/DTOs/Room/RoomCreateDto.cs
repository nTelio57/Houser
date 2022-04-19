using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using HouserAPI.Enums;

namespace HouserAPI.DTOs.Room
{
    public class RoomCreateDto
    {
        [Required]
        public string UserId { get; set; }
        [Required]
        public string Title { get; set; }
        [Required]
        public string City { get; set; }
        [Required]
        public string Address { get; set; }
        [Required]
        public float MonthlyPrice { get; set; }
        public bool UtilityBillsRequired { get; set; }
        public float Area { get; set; }
        [Required]
        public DateTime AvailableFrom { get; set; }
        [Required]
        public DateTime AvailableTo { get; set; }
        public int FreeRoomCount { get; set; }
        public int TotalRoomCount { get; set; }
        public int BedCount { get; set; }
        public BedType BedType { get; set; }
        public ICollection<Models.Image> Images { get; set; }
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
    }
}
