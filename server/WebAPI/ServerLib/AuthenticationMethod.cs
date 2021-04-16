using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace ServerLib
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum AuthenticationMethod
    {
        /// <summary>
        /// Authentication method Firebase specifies that Google Firebase is/was used as the authentication method by an user
        /// </summary>
        Firebase,

        /// <summary>
        /// Authentication method Debug specifies that no authentication should be done and all users should be allowed. 
        /// </summary>
        Debug
    }
}
