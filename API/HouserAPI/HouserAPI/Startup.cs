using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using HouserAPI.Data;
using HouserAPI.Data.Seed;
using HouserAPI.Extensions;
using HouserAPI.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using Newtonsoft.Json.Serialization;

namespace HouserAPI
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSwagger();

            var connectionStringBuilder = new MySqlConnectionStringBuilder(Configuration.GetConnectionString("HouserConnection"))
            {
                Server = Configuration["Server"],
                Database = Configuration["Database"],
                UserID = Configuration["User"],
                Password = Configuration["Password"]
            };
            services.AddDbContext<DatabaseContext>(opt =>
                opt.UseMySQL(connectionStringBuilder.ConnectionString));

            services.AddControllers().AddNewtonsoftJson(s =>
            {
                s.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
            });

            services.AddCors(o => o.AddPolicy("MyPolicy", policyBuilder =>
            {
                policyBuilder.AllowAnyOrigin()
                    .AllowAnyMethod()
                    .AllowAnyHeader();
            }));

            services.AddIdentity<User, IdentityRole>()
                .AddEntityFrameworkStores<DatabaseContext>()
                .AddDefaultTokenProviders();
            services.ConfigureIdentityOptions();

            services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
            services.AddJwtAuthentication(Configuration);

            services.AddAuthorizationDependencies(Configuration);
            services.AddRepositoriesDependencies();
            services.AddServiceDependencies();
        }
        
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, DatabaseContext context, UserManager<User> userManager, RoleManager<IdentityRole> roleManager)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "HouserAPI v1"));

                var seed = new SeedData(context, userManager, roleManager);
                seed.Seed();
            }

            app.UseCors("MyPolicy");
            app.UseHttpsRedirection();
            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
