using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    public record AuthenticationResult(bool IsSuccessful, string AuthenticatedIdentifier = null)
    {
        public static AuthenticationResult Successful(string authenticatedIdentifier) =>
            new AuthenticationResult(true, authenticatedIdentifier);

        public static AuthenticationResult Unsuccessful() =>
            new AuthenticationResult(false);
    }
}
