using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    /// <summary>
    /// Interface specifying the methods an authenticator
    /// should implement.
    /// </summary>
    public interface IAuthenticator
    {
        /// <summary>
        /// Authenticates a user with the specified identifier and password
        /// </summary>
        /// <param name="identifier">The identifier to use to authenticate the user</param>
        /// <param name="password">The password to use to authenticate the user</param>
        /// <returns>The result of the authentication</returns>
        Task<AuthenticationResult> Authenticate(string identifier, string password);

        /// <summary>
        /// Deauthenticates a user with the specified identifier
        /// </summary>
        /// <param name="identifier">The identifier to use to authenticate the user</param>
        Task Deauthenticate(string identifier);

        /// <summary>
        /// Initializes the authenticator so that is it usable.
        /// </summary>
        /// <returns></returns>
        Task Initialize();
    }
}
