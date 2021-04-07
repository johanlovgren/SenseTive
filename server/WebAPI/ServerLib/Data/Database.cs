using MySql.Data.MySqlClient;

using MySqlConnector;

using SqlKata.Compilers;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    public class Database : rDB.Database<MySqlConnection>
    {
        private readonly DatabaseSettings _settings;

        public Database(DatabaseSettings settings) : base(new MySqlCompiler())
        {
            _settings = settings;
        }

        protected override async Task<MySqlConnection> GetConnection()
        {
            var connection = new MySqlConnection(_settings.GetConnectionString());

            await connection.OpenAsync().ConfigureAwait(false);

            return connection;
        }

        private async Task<DatabaseConnectionContext<MySqlConnection>> CreateConnectionContext() =>
            new DatabaseConnectionContext<MySqlConnection>(
                await GetConnection().ConfigureAwait(false),
                SqlCompiler,
                Schema);

        public new async Task<DatabaseConnectionContext<MySqlConnection>> GetConnectionContext() =>
            await base.GetConnectionContext(() => CreateConnectionContext())
            .ConfigureAwait(false);
    }
}
