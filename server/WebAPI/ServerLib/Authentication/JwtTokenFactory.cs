using JWT;
using JWT.Algorithms;

using ServerLib.Settings;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    public class JwtTokenFactory
    {
        private readonly IJwtEncoder _jwtEncoder;

        private readonly byte[] _secret;

        public JwtTokenFactory(IJwtEncoder jwtEncoder, JwtSettings settings)
        {
            _jwtEncoder = jwtEncoder;

            _secret = Encoding.UTF8.GetBytes(settings.Secret);
        }

        public string Encode(TokenData data) => _jwtEncoder.Encode(data, _secret);
    }
}
