using JWT.Algorithms;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Settings
{
    public class JwtSettings
    {
        public string Secret { get; set; } = "!AZ7miTSGjNXKuhYDWjXQk@!mt7AWbN9&M$K32^M";
        public bool ForceSignatureVerification { get; set; } = true;
    }
}
