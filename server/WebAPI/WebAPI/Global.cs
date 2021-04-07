using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace WebAPI
{
    public static class Global
    {
        public static readonly string DataDirectory = Path.Combine(Environment.CurrentDirectory, "Data");
    }
}
