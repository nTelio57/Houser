using HouserAPI.Data.Repositories;
using HouserAPI.Models;
using HouserAPI.Services;
using Microsoft.Extensions.DependencyInjection;

namespace HouserAPI.Extensions
{
    public static class DependencyExtensions
    {
        public static IServiceCollection AddRepositoriesDependencies(this IServiceCollection services)
        {
            return services
                .AddScoped<IRepository<Image>, ImageRepository>()
                .AddScoped<IRepository<Room>, RoomRepository>()
                .AddScoped<IRepository<Filter>, FilterRepository>()
                .AddScoped<IRepository<UserFilter>, UserFilterRepository>()
                .AddScoped<IRepository<RoomFilter>, RoomFilterRepository>()
                .AddScoped<IRepository<Swipe>, SwipeRepository>()
                .AddScoped<IRepository<Match>, MatchRepository>();
        }

        public static IServiceCollection AddServiceDependencies(this IServiceCollection services)
        {
            return services
                .AddScoped<ApiClient>()
                .AddScoped<IImageService, ImageService>()
                .AddScoped<IRoomService, RoomService>()
                .AddScoped<IRecommendationService, RecommendationService>()
                .AddScoped<IFilterService, FilterService>()
                .AddScoped<IMatchService, MatchService>();
        }
    }
}
