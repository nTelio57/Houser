using System;
using HouserAPI.Data;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MySql.Data.MySqlClient;

namespace HouserAPI.Extensions
{
    public static class DatabaseConnectionExtension
    {
        public static IServiceCollection AddDatabaseContext(this IServiceCollection services, IConfiguration configuration, IWebHostEnvironment env)
        {
            var connectionStringBuilder = new MySqlConnectionStringBuilder(configuration.GetConnectionString("HouserConnection"))
            {
                Server = configuration["Server"],
                Database = configuration["Database"],
                UserID = configuration["User"],
                Password = configuration["Password"]
            };

            var connectionString = env.IsDevelopment()
                ? connectionStringBuilder.ConnectionString
                : Environment.GetEnvironmentVariable("HEROKU_DATABASE");
            connectionString = configuration["HerokuDatabase"];
            connectionString = configuration.GetConnectionString("HouserConnection");

            return services.AddDbContext<DatabaseContext>(opt =>
                opt.UseMySQL(connectionString));
        }
    }
}
