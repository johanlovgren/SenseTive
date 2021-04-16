using ServerLib.Settings;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    public class DebugAuthenticator : IAuthenticator
    {
        private readonly bool _authenticationResult;

        public DebugAuthenticator(AuthenticationSettings settings)
        {
            _authenticationResult = settings.AllowDebugMode;
        }

        public async Task<AuthenticationResult> Authenticate(string identifier, string password)
        {
            return _authenticationResult 
                ? AuthenticationResult.Successful(identifier)
                : AuthenticationResult.Unsuccessful();
        }

        public async Task Initialize()
        {
            
        }
    }
}
