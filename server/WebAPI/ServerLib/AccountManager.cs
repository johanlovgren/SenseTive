using rDB;

using ServerLib.Data;

using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib
{
    public class AccountManager
    {
        private readonly Database _database;

        public AccountManager(Database database)
        {
            _database = database;
        }

        public async Task<DbUser> GetOrCreateUser(AuthenticationMethod method, string identifier)
        {
            await using var userTable = await _database.Table<DbUser>()
                .ConfigureAwait(false);

            var loginTable = userTable.Table<DbUserLogin>();

            var userTableName = userTable.TableName;
            var loginTableName = loginTable.TableName;

            var q = userTable.Query()
                .WhereExists(loginTable.Query()
                    .Where($"{loginTableName}.{nameof(DbUserLogin.LoginMethod)}", "=", method.ToString())
                    .Where($"{loginTableName}.{nameof(DbUserLogin.LoginIdentifier)}", "=", identifier)
                    .WhereColumns($"{loginTableName}.{nameof(DbUserLogin.UserId)}", "=", $"{userTableName}.{nameof(DbUser.UserId)}"));

            var existingUser = await userTable.SelectFirstOrDefault(query => q)
                .ConfigureAwait(false);

            if (existingUser != null)
                return existingUser;

            var user = await CreateUser(userTable)
                .ConfigureAwait(false);

            if (user == null)
                throw new Exception("Could not create user in database.");

            var login = await CreateLogin(loginTable, user, method, identifier)
                .ConfigureAwait(false);

            if (login == null)
                throw new Exception("Could not create user login in database.");

            return user;
        }

        public async Task<DbUser> CreateUser<TConnection>(
            TableConnectionContext<DbUser, TConnection> userTable)
            where TConnection : DbConnection
        {
            var userId = Guid.NewGuid();

            var user = new DbUser()
            {
                UserId = userId.ToString()
            };

            var inserted = await userTable.Insert(user).ConfigureAwait(false);

            if (inserted < 1)
                throw new Exception("Could not insert user into database.");

            return user;
        }

        public async Task<DbUserLogin> CreateLogin<TConnection>(
            TableConnectionContext<DbUserLogin, TConnection> loginTable, DbUser user, AuthenticationMethod authMethod, string authIdentifier)
            where TConnection : DbConnection
        {
            var authMethodString = authMethod.ToString();

            var queryProcessor = new QueryProcessor(
                query => query.Where(nameof(DbUserLogin.UserId), "=", user.UserId),
                query => query.Where(nameof(DbUserLogin.LoginMethod), "=", authMethodString),
                query => query.Where(nameof(DbUserLogin.LoginIdentifier), "=", authIdentifier));

            await loginTable.Insert(new DbUserLogin()
                {
                    UserId = user.UserId,
                    LoginMethod = authMethodString,
                    LoginIdentifier = authIdentifier
                })
                .ConfigureAwait(false);

            return await loginTable.SelectFirstOrDefault(queryProcessor)
                .ConfigureAwait(false);
        }
    }
}
