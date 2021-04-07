using rDB;
using rDB.Attributes;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    [DatabaseTable("user_login")]
    public class DbUserLogin : DatabaseEntry
    {
        [DatabaseColumn("VARCHAR(36)", IsPrimaryKey = true, NotNull = true)]
        public string UserId { get; private set; }

        [DatabaseColumn("VARCHAR(32)", IsPrimaryKey = true, NotNull = true)]
        public int LoginMethod { get; private set; }

        [DatabaseColumn("VARCHAR(256)", IsPrimaryKey = true, NotNull = true)]
        public string LoginIdentifier { get; set; }
    }
}
