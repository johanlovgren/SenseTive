using JWT;
using JWT.Algorithms;

using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using ServerLib.Authentication;
using ServerLib.Data;
using ServerLib.Settings;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Extensions
{
    public static class ServiceExtensions
    {
        public static IServiceCollection AddServerLib(this IServiceCollection services)
        {
            services
                .AddSingleton(provider => provider
                    .GetService<IConfiguration>()
                    .GetSection<DatabaseSettings>())
                .AddTransient<DatabaseBuilder>()
                .AddSingleton(provider => provider
                    .GetService<IConfiguration>()
                    .GetSection<JwtSettings>())
                .AddSingleton<IJwtAlgorithm, HMACSHA256Algorithm>()
                .AddSingleton<IJwtEncoder, JwtEncoder>()
                .AddSingleton<JwtTokenFactory>()
                .AddSingleton<AccountManager>()
                .AddSingleton(provider => provider
                    .GetService<DatabaseBuilder>()
                    .Build().Result);

            return services;
        }
    }
}
