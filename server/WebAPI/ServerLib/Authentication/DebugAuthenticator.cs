using ServerLib.Settings;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    /// <summary>
    /// Debug authenticator which can be configured by authentication settings
    /// to allow or deny all attempted authentications with the debug authentication 
    /// type.
    /// </summary>
    public class DebugAuthenticator : IAuthenticator
    {
        private readonly bool _authenticationResult;

        public DebugAuthenticator(AuthenticationSettings settings)
        {
            _authenticationResult = settings.AllowDebugMode;
        }

        /// <summary>
        /// Authenticates a user with the given identifier and password.
        /// The result of this authentication is specified in authentication
        /// settings, and is independant of the identifier and password supplied.
        /// </summary>
        /// <param name="identifier">The identifier to use to authenticate the user</param>
        /// <param name="password">The password to use to authenticate the user</param>
        /// <returns>The result of the authentication, as specified in authentication settings. 
        /// The resulting authenticated identifier (if authentication is successful) is the 
        /// identifier provided as <paramref name="identifier"/>.</returns>
        public async Task<AuthenticationResult> Authenticate(string identifier, string password)
        {
            return _authenticationResult 
                ? AuthenticationResult.Successful(identifier)
                : AuthenticationResult.Unsuccessful();
        }

        /// <summary>
        /// Initializes this authenticator
        /// </summary>
        /// <returns></returns>
        public async Task Initialize()
        {
            
        }
    }
}
