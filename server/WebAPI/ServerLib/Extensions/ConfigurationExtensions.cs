using Microsoft.Extensions.Configuration;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Extensions
{
    public static class ConfigurationExtensions
    {
        public static T GetSection<T>(this IConfiguration configuration, string sectionName = null) => 
            configuration.GetSection(sectionName ?? typeof(T).Name).Get<T>();
    }
}
