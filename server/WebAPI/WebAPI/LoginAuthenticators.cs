using ServerLib;
using ServerLib.Authentication;
using ServerLib.Firebase;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;

using ServerLib.Settings;
using ServerLib.Extensions;

namespace WebAPI
{
    public static class LoginAuthenticators
    {
        public static IServiceCollection AddLoginAuthenticators(this IServiceCollection services) => services
            .AddFirebase()
            .AddSingleton(provider => provider
                .GetService<IConfiguration>()
                .GetSection<AuthenticationSettings>() ?? new AuthenticationSettings())
            .AddSingleton<DebugAuthenticator>()
            .AddSingleton<AuthenticatorRepository>()
            .AddSingleton<Func<AuthenticationMethod, IAuthenticator>>(
                serviceProvider => authenticationMethod => PickLoginAuthenticator(serviceProvider, authenticationMethod));

        public static IAuthenticator PickLoginAuthenticator(IServiceProvider serviceProvider, AuthenticationMethod method) =>
            method switch
            {
                AuthenticationMethod.Firebase => serviceProvider.GetService<FirebaseAuthenticator>(),
                AuthenticationMethod.Debug => serviceProvider.GetService<DebugAuthenticator>(),
                _ => throw new NotImplementedException("The specified type of authentication method has not been implemented.")
            };
    }
}
