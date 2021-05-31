using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    /// <summary>
    /// Class representing the result of an authentication. 
    /// An instance of this class contains information on whether the
    /// authentication was successful, and the authenticated identifier, if any.
    /// </summary>
    public record AuthenticationResult(bool IsSuccessful, string AuthenticatedIdentifier, string Email)
    {
        /// <summary>
        /// Creates a successful authentication result with the 
        /// specified authentication identifier
        /// </summary>
        /// <param name="authenticatedIdentifier"></param>
        /// <returns></returns>
        public static AuthenticationResult Successful(string authenticatedIdentifier, string email) =>
            new(true, authenticatedIdentifier, email);

        /// <summary>
        /// Creates an unsuccessful authentication result with no
        /// authenticated identifier
        /// </summary>
        /// <returns></returns>
        public static AuthenticationResult Unsuccessful() =>
            new(false, null, null);
    }
}
