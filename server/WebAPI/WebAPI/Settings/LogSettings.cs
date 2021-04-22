using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI.Settings
{
    /// <summary>
    /// A class used to represent the settings for how the web API should log information.
    /// </summary>
    public class LogSettings
    {
        /// <summary>
        /// The path of where the log should be written to. 
        /// 
        /// If undefined, logs will be written to the Data directory within the working directory.
        /// </summary>
        public string LogFile { get; set; } = Path.Combine(Global.DataDirectory, "Logs", "log.log");
    }
}
