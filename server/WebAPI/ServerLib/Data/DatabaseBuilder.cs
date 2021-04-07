using MySqlConnector;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    public class DatabaseBuilder : rDB.Builder.DatabaseBuilder<Database, MySqlConnection>
    {
        public DatabaseBuilder(DatabaseSettings settings) : base(new Database(settings))
        {

        }

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
