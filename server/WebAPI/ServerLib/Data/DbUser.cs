﻿using rDB;
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

        /// <summary>
        /// The authorization level of the user
        /// </summary>
        [DatabaseColumn("VARCHAR(16)", NotNull = true, Default = "\'User\'")]
        public string Authorization { get; set; }

        /// <summary>
        /// THe users email address
        /// </summary>
        [Index(Unique = true)]
        [DatabaseColumn("TINYTEXT", NotNull = true)]
        public string Email { get; set; }

        /// <summary>
        /// The first name of the user
        /// </summary>
        [DatabaseColumn("TINYTEXT")]
        public string FirstName { get; set; }

        /// <summary>
        /// The last name of the user, or null if the user has no last name
        /// </summary>
        [DatabaseColumn("TINYTEXT")]
        public string LastName { get; set; }

        public DbUser()
        {

        }

        /// <summary>
        /// Retrieves the authorization level of the user in enum form
        /// </summary>
        /// <returns>The authorization level of the user in enum form</returns>
        public AuthorizationLevel GetAuthorizationLevel() =>
            Enum.TryParse(typeof(AuthorizationLevel), Authorization, out var authLevel)
                ? (AuthorizationLevel) authLevel
                : AuthorizationLevel.Unauthorized;
    }
}
