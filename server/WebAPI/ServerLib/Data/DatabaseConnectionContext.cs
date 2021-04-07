using rDB;

using SqlKata.Compilers;

using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    public class DatabaseConnectionContext<TConnection> : ConnectionContext<TConnection>
        where TConnection : DbConnection
    {
        public DatabaseConnectionContext(TConnection connection, Compiler compiler, SchemaContext schema)
            : base(connection, compiler, schema)
        {

        }


    }
}
