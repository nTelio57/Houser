using System.Linq;
using HouserAPI.Models;

namespace HouserAPI.Data.Seed
{
    public static class ImageSeed
    {
        public static void Seed(DatabaseContext context)
        {
            var image1 = new Image
            {
                Id = 1,
                Path = "E:\\GitHub\\Houser\\API\\HouserAPI\\HouserAPI\\Images\\Seed\\2022040221230518.jpg",
                IsMain = true,
                UserId = UserSeed.IdAdmin,
                RoomId = 1
            };

            var image2 = new Image
            {
                Id = 2,
                Path = "E:\\GitHub\\Houser\\API\\HouserAPI\\HouserAPI\\Images\\Seed\\2022040221311258.jpg",
                IsMain = true,
                UserId = UserSeed.IdAdmin,
                RoomId = 2
            };

            var image3 = new Image
            {
                Id = 3,
                Path = "E:\\GitHub\\Houser\\API\\HouserAPI\\HouserAPI\\Images\\Seed\\2022040221311520.jpg",
                IsMain = true,
                UserId = UserSeed.IdBasic,
                RoomId = 3
            };

            var image4 = new Image
            {
                Id = 4,
                Path = "E:\\GitHub\\Houser\\API\\HouserAPI\\HouserAPI\\Images\\Seed\\2022041201210199.jpeg",
                IsMain = false,
                UserId = UserSeed.IdAdmin,
                RoomId = 1
            };

            var image5 = new Image
            {
                Id = 5,
                Path = "E:\\GitHub\\Houser\\API\\HouserAPI\\HouserAPI\\Images\\Seed\\photo1.jpg",
                IsMain = true,
                UserId = UserSeed.IdBasic,
                RoomId = null
            };

            var image6 = new Image
            {
                Id = 6,
                Path = "E:\\GitHub\\Houser\\API\\HouserAPI\\HouserAPI\\Images\\Seed\\photo2.jpg",
                IsMain = true,
                UserId = UserSeed.IdAdmin,
                RoomId = null
            };

            foreach (var image in new[] { image1, image2, image3, image4, image5, image6 })
            {
                var result = context.Images.FirstOrDefault(x => x.Id == image.Id);
                if (result is null) context.Images.AddAsync(image);
            }
        }
    }
}
