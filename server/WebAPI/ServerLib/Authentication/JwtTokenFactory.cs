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
    /// <summary>
    /// A factory class responsible for producing JWT tokens
    /// </summary>
    public class JwtTokenFactory
    {
        private readonly IJwtEncoder _jwtEncoder;

        private readonly byte[] _secret;

        public JwtTokenFactory(IJwtEncoder jwtEncoder, JwtSettings settings)
        {
            _jwtEncoder = jwtEncoder;

            _secret = Encoding.UTF8.GetBytes(settings.Secret);
        }

        /// <summary>
        /// Encodes specified <paramref name="data">token data</paramref> as a JWT token
        /// </summary>
        /// <param name="data">The data to encode</param>
        /// <returns>The resulting signed JWT token</returns>
        public string Encode(TokenData data) => _jwtEncoder.Encode(data, _secret);
    }
}
