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

        public async Task Initialize() => await Initialize(CancellationToken.None)
            .ConfigureAwait(false);

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

            _firebaseApp = FirebaseApp.Create(options);
            _firebaseAuth = FirebaseAuth.GetAuth(_firebaseApp);
        }

        public async Task<AuthenticationResult> Authenticate(string identifier, string password)
        {
            try
            {
                var token = await _firebaseAuth.VerifyIdTokenAsync(identifier)
                    .ConfigureAwait(false);

                return AuthenticationResult.Successful(token.Uid);
            } catch (FirebaseAuthException ex)
            {
                _logger.LogError(ex, "An exception has occurred while identifying user with firebase.");
                return AuthenticationResult.Unsuccessful();
            }
        }
    }
}
