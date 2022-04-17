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
                .AddScoped<IRepository<Offer>, OfferRepository>();
        }

        public static IServiceCollection AddServiceDependencies(this IServiceCollection services)
        {
            return services
                .AddScoped<ApiClient>()
                .AddScoped<IImageService, ImageService>()
                .AddScoped<IOfferService, OfferService>()
                .AddScoped<IRecommendationService, RecommendationService>();
        }
    }
}
