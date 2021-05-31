using JWT;

using Microsoft.AspNetCore.Http;

using ServerLib.Authentication;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI
{
    public class JwtMiddleware
    {
        private readonly RequestDelegate _delegate;
        private readonly IJwtDecoder _decoder;

        public JwtMiddleware(RequestDelegate requestDelegate, IJwtDecoder decoder)
        {
            _delegate = requestDelegate;
            _decoder = decoder;
        }

        public async Task Invoke(HttpContext context)
        {
            var token = context.Request.Headers["Authorization"].FirstOrDefault();

            if (token != null)
            {
                try
                {
                    var spaceIndex = token.LastIndexOf(' ');
                    if (spaceIndex >= 0 && token.Length > spaceIndex + 2)
                        token = token.Substring(spaceIndex + 1);

                    var decoded = _decoder.DecodeToObject<TokenData>(new JwtParts(token));

                    if (decoded != null && decoded.IsValid())
                    {
                        context.Items.TryAdd(nameof(TokenData), decoded);
                    }
                }
                catch
                {

                }
            }

            await _delegate(context)
                .ConfigureAwait(false);
        }
    }
}
