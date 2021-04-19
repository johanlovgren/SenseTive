using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    /// <summary>
    /// A repository of authenticators which is capable of authenticating
    /// a user if the authentication method is specified.
    /// </summary>
    public class AuthenticatorRepository
    {
        private readonly Func<AuthenticationMethod, IAuthenticator> _authenticatorProvider;

        public AuthenticatorRepository(Func<AuthenticationMethod, IAuthenticator> authenticatorProvider)
        {
            _authenticatorProvider = authenticatorProvider;
        }

        /// <summary>
        /// Authenticates credentials using the specified authentication method
        /// </summary>
        /// <param name="authMethod">The authentication method to use to authenticate the user</param>
        /// <param name="identifier">The identifier to use to authenticate the user</param>
        /// <param name="password">The password to use to authenticate the user</param>
        /// <returns>The result of the authentication</returns>
        public async Task<AuthenticationResult> Authenticate(AuthenticationMethod authMethod, string identifier, string password)
        {
            var authenticator = _authenticatorProvider(authMethod);

            if (authenticator == null)
                throw new NotImplementedException("The specified authentication method is not implemented.");

            await authenticator.Initialize()
                .ConfigureAwait(false);

            return await authenticator.Authenticate(identifier, password)
                .ConfigureAwait(false);
        }
    }
}
