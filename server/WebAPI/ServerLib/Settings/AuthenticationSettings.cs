using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Settings
{
    /// <summary>
    /// Authentication settings defining parameters to use 
    /// for user authentication
    /// </summary>
    public class AuthenticationSettings
    {
        /// <summary>
        /// Toggle whether or not debug authentication should be enabled.
        /// Enabling this allows any user to authenticate themselves with any
        /// credentials.
        /// </summary>
        public bool AllowDebugMode { get; set; } = false;
    }
}
