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
                .AddScoped<IRepository<Image>, ImageRepository>();
        }

        public static IServiceCollection AddServiceDependencies(this IServiceCollection services)
        {
            return services
                .AddScoped<IImageService, ImageService>();
        }
    }
}
