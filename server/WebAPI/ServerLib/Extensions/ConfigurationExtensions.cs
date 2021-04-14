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
        /// <summary>
        /// Utility function to retrieve and bind a specific section of a configuration.
        /// </summary>
        /// <typeparam name="T">The type retrieve the section as</typeparam>
        /// <param name="configuration">The configuration to retrieve the section from</param>
        /// <param name="sectionName">The name of the section to retrieve. 
        /// If undefined, the name of the type to retrieve the section as is used.</param>
        /// <returns>An instance of the specified type representing the section.</returns>
        public static T GetSection<T>(this IConfiguration configuration, string sectionName = null) => 
            configuration.GetSection(sectionName ?? typeof(T).Name).Get<T>();
    }
}
