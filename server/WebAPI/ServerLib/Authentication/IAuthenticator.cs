using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    public interface IAuthenticator
    {
        Task<AuthenticationResult> Authenticate(string identifier, string password);
        Task Initialize();
    }
}
