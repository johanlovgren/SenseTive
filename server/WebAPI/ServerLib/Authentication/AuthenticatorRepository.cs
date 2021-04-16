using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    public class AuthenticatorRepository
    {
        private readonly Func<AuthenticationMethod, IAuthenticator> _authenticatorProvider;

        public AuthenticatorRepository(Func<AuthenticationMethod, IAuthenticator> authenticatorProvider)
        {
            _authenticatorProvider = authenticatorProvider;
        }

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
