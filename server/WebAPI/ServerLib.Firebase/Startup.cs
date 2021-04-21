using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using System;

using ServerLib.Extensions;

namespace ServerLib.Firebase
{
    public static class Startup
    {
        /// <summary>
        /// Adds Firebase related classes to a specified service collection
        /// </summary>
        /// <param name="services">The service collection to add Firebase classes to</param>
        /// <returns>The service collection provided as <paramref name="services"/></returns>
        public static IServiceCollection AddFirebase(this IServiceCollection services)
        {
            services
                .AddSingleton(provider => provider
                    .GetService<IConfiguration>()
                    .GetSection<FirebaseSettings>())
                .AddSingleton<FirebaseAuthenticator>();

            return services;
        }
    }
}
