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

        [DatabaseColumn("VARCHAR(16)", NotNull = true, Default = "\'User\'")]
        public string Authorization { get; set; }

        public DbUser()
        {

        }

        public AuthorizationLevel GetAuthorizationLevel() =>
            Enum.TryParse(typeof(AuthorizationLevel), Authorization, out var authLevel)
                ? (AuthorizationLevel) authLevel
                : AuthorizationLevel.Unauthorized;
    }
}
