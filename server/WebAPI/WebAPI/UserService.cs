using Microsoft.AspNetCore.Http;

using ServerLib.Authentication;
using ServerLib.Data;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI
{
    public class UserService
    {
        private readonly Database _database;

        public UserService(Database database)
        {
            _database = database;
        }

        public TokenData GetTokenData(HttpContext context) =>
            context.Items.TryGetValue(nameof(TokenData), out var data) && data is TokenData tokenData
                ? tokenData
                : null;

        public async Task<DbUser> GetUser(HttpContext context)
        {
            var tokenData = GetTokenData(context);

            if (tokenData == null)
                return null;

            var userId = tokenData.UserId;
            var guid = Guid.Parse(userId);
            var table = await _database.Table<DbUser>()
                .ConfigureAwait(false);

            return await table.SelectFirstOrDefault<DbUser>(query => query
                .Where(nameof(DbUser.UserId), "=", guid.ToString()));
        }
    }
}
