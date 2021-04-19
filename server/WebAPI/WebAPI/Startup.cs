using JWT;
using JWT.Algorithms;

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using Serilog;

using ServerLib;
using ServerLib.Authentication;
using ServerLib.Data;
using ServerLib.Extensions;
using ServerLib.Firebase;
using ServerLib.Settings;

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

        /// <summary>
        /// Configures the services to use to create the web API host.
        /// </summary>
        /// <param name="services">The service collection to add and configure services to</param>
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services
                .AddSingleton(Configuration)
                .AddServerLib()
                .AddLoginAuthenticators()
                .AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtAuthenticationDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtAuthenticationDefaults.AuthenticationScheme;
                })
                .AddJwt(options =>
                {
                    var settings = Configuration.GetSection<JwtSettings>();

                    options.Keys = new string[] { settings.Secret };
                    options.VerifySignature = settings.ForceSignatureVerification;
                });
        }

        /// <summary>
        /// Configures the application builder and specifies how HTTP requests are handled.
        /// </summary>
        /// <param name="app">The builder used to construct the application.</param>
        /// <param name="env">The environment of the web API host</param>
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
                app.UseDeveloperExceptionPage();

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
