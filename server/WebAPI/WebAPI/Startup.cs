using JWT;

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using Serilog;

using ServerLib.Data;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using WebAPI.Data;
using WebAPI.Settings;

namespace WebAPI
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services
                .AddSingleton(provider => provider
                        .GetService<IConfiguration>()
                        .GetSection(nameof(DatabaseSettings))
                        .Get<DatabaseSettings>())
                .AddSingleton<DatabaseBuilder>()
                .AddSingleton(provider => provider
                    .GetService<DatabaseBuilder>()
                    .Build().Result)          
                .AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtAuthenticationDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtAuthenticationDefaults.AuthenticationScheme;
                })
                .AddJwt(options =>
                {
                    var settings = Configuration
                        .GetSection(nameof(JwtSettings))
                        .Get<JwtSettings>();

                    options.Keys = settings.Keys;
                    options.VerifySignature = settings.ForceSignatureVerification;
                });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseSerilogRequestLogging();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
