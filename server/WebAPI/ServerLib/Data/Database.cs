using MySqlConnector;

using SqlKata.Compilers;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    /// <summary>
    /// A Database class useful to open connections and access data of a
    /// MySql-derived database.
    /// </summary>
    public class Database : rDB.Database<MySqlConnection>
    {
        private readonly DatabaseSettings _settings;

        public Database(DatabaseSettings settings) : base(new MySqlCompiler())
        {
            _settings = settings;
            QuoteColumnNames = false;
        }

        /// <summary>
        /// Asynchronously creates a connection to the MySql-derived database
        /// </summary>
        /// <returns>An opened connection to the database</returns>
        protected override async Task<MySqlConnection> GetConnection()
        {
            var connection = new MySqlConnection(_settings.GetConnectionString());

            await connection.OpenAsync().ConfigureAwait(false);

            return connection;
        }

        /// <summary>
        /// Asynchronously creates and opens a connection context to the database
        /// </summary>
        /// <returns>An opened connection context.</returns>
        private async Task<DatabaseConnectionContext<MySqlConnection>> CreateConnectionContext() =>
            new DatabaseConnectionContext<MySqlConnection>(
                await GetConnection().ConfigureAwait(false),
                SqlCompiler,
                Schema);

        /// <summary>
        /// Asynchronously creates and configures a connection context so that it is usable to 
        /// access the database.
        /// </summary>
        /// <returns>The usable connection context that can be used to access the database.</returns>
        public new async Task<DatabaseConnectionContext<MySqlConnection>> GetConnectionContext() =>
            await base.GetConnectionContext(() => CreateConnectionContext())
            .ConfigureAwait(false);
    }
}
