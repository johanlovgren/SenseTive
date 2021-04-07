using JWT;
using JWT.Algorithms;

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using Serilog;

using ServerLib.Authentication;
using ServerLib.Data;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using WebAPI.Settings;

namespace WebAPI
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services
                .AddSingleton(Configuration)
                .AddSingleton(Configuration
                    .GetSection(nameof(DatabaseSettings))
                    .Get<DatabaseSettings>())
                .AddSingleton(Configuration
                    .GetSection(nameof(JwtSettings))
                    .Get<JwtSettings>())
                .AddSingleton<IJwtAlgorithm, HMACSHA256Algorithm>()
                .AddSingleton<IJwtEncoder, JwtEncoder>()
                .AddSingleton<JwtTokenFactory>()
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
            app.UseAuthentication();

            app.UseSerilogRequestLogging();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
