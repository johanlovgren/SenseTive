using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

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

        public AccountController(Database database, UserService userService)
        {
            _database = database;
            _userService = userService;
        }

        [HttpDelete]
        [Route("/[controller]/delete")]
        public async Task Delete()
        {
            var tokenData = _userService.GetTokenData(HttpContext);

            if (tokenData == null)
                return;

            await using var table = await _database.Table<DbUser>()
                .ConfigureAwait(false);

            var deleted = await table.Delete(query => query
                .Where(nameof(DbUser.UserId), "=", tokenData.UserGuid.ToString()))
                .ConfigureAwait(false);

            if (deleted <= 0)
                NotFound();
        }
    }
}
