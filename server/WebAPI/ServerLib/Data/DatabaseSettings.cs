using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    public class DatabaseSettings
    {
        /// <summary>
        /// The hostname of the database (i.e. address)
        /// </summary>
        public string Hostname { get; set; }

        /// <summary>
        /// The port of the database
        /// </summary>
        public int Port { get; set; }

        /// <summary>
        /// The username to use to connect to the database.
        /// </summary>
        public string Username { get; set; }

        /// <summary>
        /// The password to use to connect to the database.
        /// </summary>
        public string Password { get; set; }

        /// <summary>
        /// The name of the database to use.
        /// </summary>
        public string Database { get; set; }

        /// <summary>
        /// Compiles a connection string using the current state of the settings class instance.
        /// </summary>
        /// <returns>A compiled database connection string.</returns>
        public string GetConnectionString() =>
            $"Server={Hostname};" +
            $"Port={Port};" +
            $"Uid={Username};" +
            $"Pwd={Password};" +
            $"Database={Database};";
    }
}
