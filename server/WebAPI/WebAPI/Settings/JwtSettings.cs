using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI.Settings
{
    public class JwtSettings
    {
        public string[] Keys { get; set; } = new[] { "!AZ7miTSGjNXKuhYDWjXQk@!mt7AWbN9&M$K32^M" };
        public bool ForceSignatureVerification { get; set; } = true;
    }
}
