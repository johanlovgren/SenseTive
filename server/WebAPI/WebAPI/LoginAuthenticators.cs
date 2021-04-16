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
using System.Diagnostics.CodeAnalysis;

namespace WebAPI
{
    public static class LoginAuthenticators
    {
        /// <summary>
        /// Adds all login authenticators to a specified service collection
        /// </summary>
        /// <param name="services">The service collection to add the login authenticators to</param>
        /// <returns>The service collection, as provided by <paramref name="services"/></returns>
        public static IServiceCollection AddLoginAuthenticators(this IServiceCollection services) => services
            .AddFirebase()
            .AddSingleton(provider => provider
                .GetService<IConfiguration>()
                .GetSection<AuthenticationSettings>() ?? new AuthenticationSettings())
            .AddSingleton<DebugAuthenticator>()
            .AddSingleton<AuthenticatorRepository>()
            .AddSingleton<Func<AuthenticationMethod, IAuthenticator>>(
                serviceProvider => authenticationMethod => PickLoginAuthenticator(serviceProvider, authenticationMethod));

        /// <summary>
        /// Selects an authenticator from a service provider using the specified 
        /// authentication method
        /// </summary>
        /// <param name="serviceProvider">The service provider to select the authenticator from</param>
        /// <param name="method">The authentication method to use to select the authenticator</param>
        /// <returns>The authenticator associated with the specified authentication method. 
        /// If no such authenticator is found, a <see cref="NotImplementedException"/> is thrown since
        /// the specified authentication method therefore is not implemented or supported.</returns>
        [return: NotNull]
        public static IAuthenticator PickLoginAuthenticator(IServiceProvider serviceProvider, AuthenticationMethod method) =>
            method switch
            {
                AuthenticationMethod.Firebase => serviceProvider.GetService<FirebaseAuthenticator>(),
                AuthenticationMethod.Debug => serviceProvider.GetService<DebugAuthenticator>(),
                _ => throw new NotImplementedException("The specified type of authentication method has not been implemented.")
            };
    }
}
