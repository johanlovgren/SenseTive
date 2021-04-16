using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using System;

using ServerLib.Extensions;

namespace ServerLib.Firebase
{
    public static class Startup
    {
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
