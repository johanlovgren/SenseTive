using rDB;
using rDB.Attributes;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    [DatabaseTable("user")]
    public class DbUser : DatabaseEntry
    {
        /// <summary>
        /// The GUID of the user in string form
        /// </summary>
        [DatabaseColumn("VARCHAR(36)", IsPrimaryKey = true, NotNull = true)]
        public string UserId { get; set; }

        public DbUser()
        {

        }
    }
}
