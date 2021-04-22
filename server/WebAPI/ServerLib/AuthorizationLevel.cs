using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace ServerLib
{
    
    [JsonConverter(typeof(JsonStringEnumConverter))]
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum AuthorizationLevel
    {
        /// <summary>
        /// Authorization level unauthorized is granted to a user with no privileges
        /// </summary>
        Unauthorized = 0,

        /// <summary>
        /// Authorization level User is granted to a user with normal privileges
        /// </summary>
        User = 1,

        /// <summary>
        /// Authorization level Admin is granted to a user with admin privileges
        /// </summary>
        Admin = 2
    }
}
