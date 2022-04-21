using System;
using System.Linq;
using HouserAPI.Enums;
using HouserAPI.Models;

namespace HouserAPI.Data.Seed
{
    public static class RoomSeed
    {
        public static void Seed(DatabaseContext context)
        {
            var room1 = new Room
            {
                UserId = UserSeed.IdAdmin,
                IsVisible = true,
                UploadDate = new DateTime(2022, 2, 24),
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
                AccommodationAc = false,
            };

            var room2 = new Room
            {
                UserId = UserSeed.IdAdmin,
                IsVisible = true,
                UploadDate = new DateTime(2022, 2, 14),
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

            var room3 = new Room
            {
                UserId = UserSeed.IdBasic,
                IsVisible = true,
                UploadDate = new DateTime(2022, 2, 8),
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

            foreach (var room in new[] {room1, room2, room3})
            {
                var result = context.Rooms.FirstOrDefault(x => x.Id == room.Id);
                if (result is null) context.Rooms.AddAsync(room);
            }
        }
    }
}
