using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI.Settings
{
    public class LogSettings
    {
        public string LogFile { get; set; } = Path.Combine(Global.DataDirectory, "Logs", "log.log");
    }
}
