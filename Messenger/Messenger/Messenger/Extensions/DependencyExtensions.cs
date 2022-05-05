using Messenger.Data;
using Messenger.Models;
using Messenger.Services;
using Microsoft.Extensions.DependencyInjection;

namespace Messenger.Extensions
{
    public static class DependencyExtensions
    {
        public static IServiceCollection AddRepositoriesDependencies(this IServiceCollection services)
        {
            return services
                .AddScoped<IRepository<Match>, MatchRepository>()
                .AddScoped<IRepository<Message>, MessageRepository>();
        }

        public static IServiceCollection AddServiceDependencies(this IServiceCollection services)
        {
            return services
                .AddScoped<IMessageService, MessageService>();
        }
    }
}
