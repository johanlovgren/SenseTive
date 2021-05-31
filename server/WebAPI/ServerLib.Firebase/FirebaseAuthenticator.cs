using FirebaseAdmin;
using FirebaseAdmin.Auth;

using Microsoft.Extensions.Logging;

using ServerLib.Authentication;

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ServerLib.Firebase
{
    /// <summary>
    /// Firebase authenticator that uses firebase to authenticate users
    /// </summary>
    public class FirebaseAuthenticator : IAuthenticator
    {
        private readonly FirebaseSettings _settings;
        private readonly ILogger<FirebaseAuthenticator> _logger;
        private FirebaseAuth _firebaseAuth;
        private FirebaseApp _firebaseApp;

        public FirebaseAuthenticator(ILogger<FirebaseAuthenticator> logger, FirebaseSettings settings)
        {
            _logger = logger;
            _settings = settings;
        }

        /// <summary>
        /// Initializes this authenticator and the firebase API's it uses.
        /// </summary>
        /// <returns></returns>
        public async Task Initialize() => await Initialize(CancellationToken.None)
            .ConfigureAwait(false);

        /// <summary>
        /// Initializes this authenticator and the firebase API's it uses 
        /// with a specified cancellation token.
        /// </summary>
        /// <param name="token">The cancellation token to use to interrupt asynchronous operations.</param>
        /// <returns></returns>
        public async Task Initialize(CancellationToken token)
        {
            var firebaseCredentialsFile = Path.IsPathRooted(_settings.FirebaseKeyPath) 
                ? _settings.FirebaseKeyPath 
                : Path.Combine(Environment.CurrentDirectory, _settings.FirebaseKeyPath);

            if (!File.Exists(firebaseCredentialsFile))
                throw new IOException("Firebase credentials file could not be located.");

            var options = new AppOptions()
            {
                Credential = await Google.Apis.Auth.OAuth2.GoogleCredential
                    .FromFileAsync(firebaseCredentialsFile, token)
                    .ConfigureAwait(false)
            };

            const string appName = "sensetive";
            _firebaseApp = FirebaseApp.GetInstance(appName) ?? FirebaseApp.Create(options, appName);
            _firebaseAuth = FirebaseAuth.GetAuth(_firebaseApp);
        }

        /// <summary>
        /// Authenticates credentials using Firebase
        /// </summary>
        /// <param name="identifier">The identifier to authenticate</param>
        /// <param name="password">The password to authenticate</param>
        /// <returns>The result of the authentication.
        /// If successful, the authenticated identifier is the user ID provided by Firebase.</returns>
        public async Task<AuthenticationResult> Authenticate(string identifier, string password)
        {
            try
            {
                var token = await _firebaseAuth.VerifyIdTokenAsync(identifier)
                    .ConfigureAwait(false);

                var user = await _firebaseAuth.GetUserAsync(token.Uid);

                if (user == null || !user.EmailVerified || user.Email == null)
                    throw new Exception("The associated user is invalid or non existant.");

                return AuthenticationResult.Successful(token.Uid, user.Email);
            } catch (FirebaseAuthException ex)
            {
                _logger.LogError(ex, "An exception has occurred while identifying user with firebase.");
                return AuthenticationResult.Unsuccessful();
            }
        }
        
        /// <summary>
        /// Deauthenticates credentials using Firebase
        /// </summary>
        /// <param name="identifier">The identifier to deauthenticate</param>
        public async Task Deauthenticate(string identifier)
        {
            await _firebaseAuth.DeleteUserAsync(identifier)
                .ConfigureAwait(false);
        }
    }
}
