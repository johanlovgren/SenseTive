using JWT.Algorithms;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Settings
{
    public class JwtSettings
    {
        /// <summary>
        /// The secret to use to sign JWT tokens
        /// </summary>
        public string Secret { get; set; } = "!AZ7miTSGjNXKuhYDWjXQk@!mt7AWbN9&M$K32^M";

        /// <summary>
        /// Whether or not verification of signatures should be forced.
        /// </summary>
        public bool ForceSignatureVerification { get; set; } = true;

        /// <summary>
        /// For how long a token is valid before it expires.
        /// 
        /// UTC is used to calculate the token expiry time once it is created.
        /// </summary>
        public TimeSpan TokenExpiry { get; set; } = TimeSpan.FromDays(14);
    }
}
