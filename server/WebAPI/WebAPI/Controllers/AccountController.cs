using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

using Serilog;

using ServerLib;
using ServerLib.Authentication;
using ServerLib.Data;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI.Controllers
{
    [Route("[controller]")]
    [ApiController]
    [JwtAuthorize]
    public class AccountController : ControllerBase
    {
        private readonly Database _database;
        private readonly UserService _userService;
        private readonly AuthenticatorRepository _authRepository;

        public AccountController(Database database, UserService userService, AuthenticatorRepository authRepository)
        {
            _database = database;
            _userService = userService;
            _authRepository = authRepository;
        }

        [HttpGet]
        public async Task<UserResponse> Get()
        {
            var user = await _userService.GetUser(HttpContext)
                .ConfigureAwait(false);
            
            if (user == null)
            {
                NotFound();
                return null;
            }

            return new UserResponse
            {
                FirstName = user?.FirstName,
                LastName = user?.LastName,
                Email = user?.Email
            };
        }

        [HttpDelete]
        public async Task Delete()
        {
            var tokenData = _userService.GetTokenData(HttpContext);

            if (tokenData == null)
                return;

            await using var table = await _database.Table<DbUser>()
                .ConfigureAwait(false);

            var logins = await table.Table<DbUserLogin>().Select(query => query
                .Where(nameof(DbUserLogin.UserId), "=", tokenData.UserId))
                .ConfigureAwait(false);

            var deleted = await table.Delete(query => query
                .Where(nameof(DbUser.UserId), "=", tokenData.UserGuid.ToString()))
                .ConfigureAwait(false);

            if (deleted <= 0)
            {
                NotFound();
                return;
            }

            if (logins == null)
                return;

            Log.Logger.Debug("Attempting to delete user logins upon account deletion of UUID {userId}", tokenData.UserId);

            var tasks = logins
                .Where(login => login.LoginMethod == AuthenticationMethod.Firebase.ToString())
                .Select(async login =>
                    await _authRepository.Deauthenticate(AuthenticationMethod.Firebase, login.LoginIdentifier)
                    .ConfigureAwait(false));

            await Task.WhenAll(tasks);
        }

        [HttpPost]
        public async Task<UserResponse> Update([FromBody] UpdateRequest request)
        {
            var tokenData = _userService.GetTokenData(HttpContext);

            if (tokenData == null)
                return null;

            var user = await _userService.GetUser(HttpContext)
                .ConfigureAwait(false);

            if (user == null)
            {
                NotFound();
                return null;
            }

            if (request.FirstName != null)
                user.FirstName = request.FirstName;

            if (request.LastName != null)
                user.LastName = request.LastName;

            await using var table = await _database.Table<DbUser>();
            await table.UpdateWhere(query => query
                .Where(nameof(DbUser.UserId), "=", tokenData.UserId),
                user)
                .ConfigureAwait(false);

            var responseData = await table.SelectFirstOrDefault(query => query
                .Where(nameof(DbUser.UserId), "=", tokenData.UserId))
                .ConfigureAwait(false);

            return new UserResponse
            {
                FirstName = responseData?.FirstName,
                LastName = responseData?.LastName,
                Email = responseData?.Email
            };
        }

        public class UpdateRequest
        {
            public string FirstName { get; set; } = null;
            public string LastName { get; set; } = null;
        }

        public class UserResponse
        {
            public string FirstName { get; set; } = null;
            public string LastName { get; set; } = null;
            public string Email { get; set; } = null;
        }
    }
}
