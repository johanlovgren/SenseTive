using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI
{
    /// <summary>
    /// A static class containing constants used across various parts of the web API.
    /// </summary>
    public static class Global
    {
        /// <summary>
        /// The path of the Data directory, which contains files such as logs.
        /// </summary>
        public static readonly string DataDirectory = Path.Combine(Environment.CurrentDirectory, "Data");
    }
}
