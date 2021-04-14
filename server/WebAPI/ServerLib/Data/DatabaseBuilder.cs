using MySqlConnector;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    /// <summary>
    /// A builder class that is useful to construct an instance of the <see cref="Database"/> class.
    /// </summary>
    public class DatabaseBuilder : rDB.Builder.DatabaseBuilder<Database, MySqlConnection>
    {
        public DatabaseBuilder(DatabaseSettings settings) : base(new Database(settings))
        {

        }

        /// <summary>
        /// Asynchronously builds an instance of the database.
        /// </summary>
        /// <returns></returns>
        public override async Task<Database> Build()
        {
            if (TableMap == null || TableMap.Count == 0)
                WithTable(
                    new DbUserLogin()
                );

            return await base.Build().ConfigureAwait(false);
        }
    }
}
