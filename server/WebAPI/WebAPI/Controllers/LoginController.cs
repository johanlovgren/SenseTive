using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

using ServerLib;
using ServerLib.Authentication;
using ServerLib.Data;
using ServerLib.Settings;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace WebAPI.Controllers
{
    /// <summary>
    /// A controller responsible for authorizing users and granting access tokens 
    /// to use for other controllers of the system.
    /// </summary>
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class LoginController : ControllerBase
    {
        private readonly ILogger<LoginController> _logger;
        private readonly Database _database;
        private readonly JwtTokenFactory _tokenFactory;
        private readonly JwtSettings _tokenSettings;
        private readonly AuthenticatorRepository _authenticatorRepository;

        public LoginController(ILogger<LoginController> logger, Database database, JwtTokenFactory factory, JwtSettings settings,
            AuthenticatorRepository authenticatorRepository)
        {
            _logger = logger;
            _database = database;
            _tokenFactory = factory;
            _tokenSettings = settings;
            _authenticatorRepository = authenticatorRepository;
        }

        /// <summary>
        /// Handles a log in request made by a user and responds accordingly.
        /// </summary>
        /// <param name="request">The <see cref="LoginRequest">login request</see> made by the user.</param>
        /// <returns>A <see cref="LoginResponse">login response</see> if login was successful, <see langword="null"/> otherwise.</returns>
        [HttpPost]
        [AllowAnonymous]
        [Route("/[controller]")]
        public async Task<LoginResponse> Login([FromBody] LoginRequest request)
        {
            if (request == null || string.IsNullOrEmpty(request.Identifier))
            {
                Response.StatusCode = 400;
                return null;
            }

            var authResult = await _authenticatorRepository.Authenticate(request.Method, request.Identifier, request.Password)
                .ConfigureAwait(false);

            if (authResult == null)
            {
                Response.StatusCode = 500;
                return null;
            } else if (!authResult.IsSuccessful)
            {
                Response.StatusCode = 403;
                return null;
            }

            return new LoginResponse(_tokenFactory.Encode(TokenData.Create(
                Guid.Empty, 
                _tokenSettings.TokenExpiry)));
        }

        /// <summary>
        /// A class used to represent the response of a log in request.
        /// </summary>
        public class LoginResponse
        {
            /// <summary>
            /// The JWT token granted to the user if the log in request was successful.
            /// </summary>
            public string Token { get; set; }

            public LoginResponse(string token)
            {
                Token = token;
            }
        }

        /// <summary>
        /// A class used to represent the log in request submitted by a user
        /// </summary>
        public class LoginRequest
        {
            /// <summary>
            /// The log in method used by the user to log in
            /// </summary>
            public AuthenticationMethod Method { get; set; }

            /// <summary>
            /// The idenfifier to use to authenticate with the
            /// specified authentication method
            /// </summary>
            public string Identifier { get; set; }

            /// <summary>
            /// The password or key to use to authenticate with the 
            /// specified authentication method
            /// </summary>
            public string Password { get; set; }
        }
    }
}
