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

        /// <summary>
        /// Retrieves a user with the specified authentication details if one exists, otherwise, one is created.
        /// </summary>
        /// <param name="method">The authentication method used by the user</param>
        /// <param name="identifier">The authentication identifier used by the user</param>
        /// <returns>The user associated with the authentication details</returns>
        public async Task<DbUser> GetOrCreateUser(AuthenticationMethod method, string identifier, string email)
        {
            await using var userTable = await _database.Table<DbUser>()
                .ConfigureAwait(false);

            var loginTable = userTable.Table<DbUserLogin>();

            var userTableName = userTable.TableName;
            var loginTableName = loginTable.TableName;

            var existingUser = await userTable.SelectFirstOrDefault(query => query
                .WhereExists(loginTable.Query()
                    .Where($"{loginTableName}.{nameof(DbUserLogin.LoginMethod)}", "=", method.ToString())
                    .Where($"{loginTableName}.{nameof(DbUserLogin.LoginIdentifier)}", "=", identifier)
                    .WhereColumns($"{loginTableName}.{nameof(DbUserLogin.UserId)}", "=", $"{userTableName}.{nameof(DbUser.UserId)}")))
                .ConfigureAwait(false);

            if (existingUser != null)
                return existingUser;

            var user = await CreateUser(userTable, user => {
                user.Email = email;
            }).ConfigureAwait(false);

            if (user == null)
                throw new Exception("Could not create user in database.");

            var login = await CreateLogin(loginTable, user, method, identifier)
                .ConfigureAwait(false);

            if (login == null)
                throw new Exception("Could not create user login in database.");

            return user;
        }

        /// <summary>
        /// Creates a user in the database and returns the created user
        /// </summary>
        /// <typeparam name="TConnection">The type of connection used to communicate with the database</typeparam>
        /// <param name="userTable">The table to insert the user into</param>
        /// <param name="configurator">A function that can be used to modify the user</param>
        /// <returns>The created user</returns>
        public async Task<DbUser> CreateUser<TConnection>(
            TableConnectionContext<DbUser, TConnection> userTable,
            Action<DbUser> configurator = null)
            where TConnection : DbConnection
        {
            var userId = Guid.NewGuid();

            var user = new DbUser()
            {
                UserId = userId.ToString(),
                Authorization = AuthorizationLevel.User.ToString(),
            };

            configurator?.Invoke(user);

            var inserted = await userTable.Insert(user).ConfigureAwait(false);

            if (inserted < 1)
                throw new Exception("Could not insert user into database.");

            return user;
        }

        /// <summary>
        /// Creates a user login in the database and returns the created user login
        /// </summary>
        /// <typeparam name="TConnection">The type of connection used to communicate with the database</typeparam>
        /// <param name="loginTable">The database table to add the user login to</param>
        /// <param name="user">The database user to link the user login to</param>
        /// <param name="authMethod">The authentication method used for the login</param>
        /// <param name="authIdentifier">The authentication identifier used for the login</param>
        /// <param name="configurator">A function that can be used to modify the user login</param>
        /// <returns>The created user login</returns>
        public async Task<DbUserLogin> CreateLogin<TConnection>(
            TableConnectionContext<DbUserLogin, TConnection> loginTable, DbUser user, AuthenticationMethod authMethod, string authIdentifier,
            Action<DbUserLogin> configurator = null)
            where TConnection : DbConnection
        {
            var authMethodString = authMethod.ToString();

            var queryProcessor = new QueryProcessor(
                query => query.Where(nameof(DbUserLogin.UserId), "=", user.UserId),
                query => query.Where(nameof(DbUserLogin.LoginMethod), "=", authMethodString),
                query => query.Where(nameof(DbUserLogin.LoginIdentifier), "=", authIdentifier));

            var userLogin = new DbUserLogin()
            {
                UserId = user.UserId,
                LoginMethod = authMethodString,
                LoginIdentifier = authIdentifier
            };

            configurator?.Invoke(userLogin);

            await loginTable.Insert(userLogin)
                .ConfigureAwait(false);

            return await loginTable.SelectFirstOrDefault(queryProcessor)
                .ConfigureAwait(false);
        }
    }
}
