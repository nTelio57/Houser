using System;
using System.Linq;
using HouserAPI.Enums;
using HouserAPI.Models;

namespace HouserAPI.Data.Seed
{
    public static class OfferSeed
    {
        public static void Seed(DatabaseContext context)
        {
            var offer1 = new Offer
            {
                UserId = "570457bc-51a6-47d7-90a1-cc3cd1598563",
                Id = 1,
                Title = "Pirmasis pasiulymas",
                City = "Kaunas",
                Address = "K. Baršausko g. 86",
                MonthlyPrice = 100,
                UtilityBillsRequired = true,
                AvailableFrom = new DateTime(2022, 4, 27),
                AvailableTo = new DateTime(2022, 5, 27),
                FreeRoomCount = 1,
                TotalRoomCount = 2,
                BedCount = 1,
                BedType = BedType.Single,
                RuleSmoking = false,
                RuleAnimals = true,
                AccommodationTv = true,
                AccommodationWifi = true,
                AccommodationAc = false
            };

            var offer2 = new Offer
            {
                UserId = "570457bc-51a6-47d7-90a1-cc3cd1598563",
                Id = 2,
                Title = "Antrasis pasiulymas",
                City = "Vilnius",
                Address = "S. Daukanto. 21",
                MonthlyPrice = 1200,
                UtilityBillsRequired = true,
                AvailableFrom = new DateTime(2022, 4, 27),
                AvailableTo = new DateTime(2022, 5, 27),
                FreeRoomCount = 3,
                TotalRoomCount = 9,
                BedCount = 2,
                BedType = BedType.Double,
                RuleSmoking = true,
                RuleAnimals = false,
                AccommodationTv = true,
                AccommodationWifi = true,
                AccommodationAc = true
            };

            var offer3 = new Offer
            {
                UserId = "6e58169a-cc76-45b9-8d20-ef40fda183a3",
                Id = 3,
                Title = "Trečiasis pasiulymas",
                City = "Domeikava",
                Address = "Vandžiogalos pl. 57",
                MonthlyPrice = 800,
                UtilityBillsRequired = true,
                AvailableFrom = new DateTime(2022, 4, 27),
                AvailableTo = new DateTime(2022, 5, 27),
                FreeRoomCount = 4,
                TotalRoomCount = 4,
                BedCount = 1,
                BedType = BedType.Sofa,
                RuleSmoking = true,
                RuleAnimals = true,
                AccommodationTv = false,
                AccommodationWifi = true,
                AccommodationAc = true
            };

            foreach (var offer in new[] {offer1, offer2, offer3})
            {
                var result = context.Offers.FirstOrDefault(x => x.Id == offer.Id);
                if (result is null) context.Offers.AddAsync(offer);
            }
        }
    }
}
