using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    public class DatabaseSettings
    {
        public string Hostname { get; set; }
        public int Port { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string Database { get; set; }

        public string GetConnectionString() =>
            $"Server={Hostname}; " +
            $"Port={Port}; " +
            $"User ID={Username}; " +
            $"Password={Password}; " +
            $"Database={Database}; ";
    }
}
