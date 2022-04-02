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
        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            Configuration = configuration;
            WebHostEnvironment = env;
        }

        public IConfiguration Configuration { get; }
        public IWebHostEnvironment WebHostEnvironment { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSwagger();

            services.AddDatabaseContext(Configuration, WebHostEnvironment);

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

            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "HouserAPI v1");
                c.RoutePrefix = String.Empty;
            });
        }
    }
}
