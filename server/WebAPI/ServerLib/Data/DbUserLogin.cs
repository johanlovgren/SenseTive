using rDB;
using rDB.Attributes;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    /// <summary>
    /// A class representing a user login in the database
    /// </summary>
    [DatabaseTable("user_login")]
    public class DbUserLogin : DatabaseEntry
    {
        /// <summary>
        /// The GUID of the user in string form
        /// </summary>
        [ForeignKey(typeof(DbUser), nameof(DbUser.UserId))]
        [DatabaseColumn("VARCHAR(36)", IsPrimaryKey = true, NotNull = true)]
        public string UserId { get; set; }

        /// <summary>
        /// The ordinal of the <see cref="LoginMethod">login method</see> to use to authenticate the user
        /// </summary>
        [Index(Name = "login", Unique = true)]
        [DatabaseColumn("VARCHAR(32)", IsPrimaryKey = true, NotNull = true)]
        public string LoginMethod { get; set; }

        /// <summary>
        /// The login identifier used to authenticate the user
        /// </summary>
        [Index(Name = "login", Unique = true)]
        [DatabaseColumn("VARCHAR(256)", IsPrimaryKey = true, NotNull = true)]
        public string LoginIdentifier { get; set; }
    }
}
