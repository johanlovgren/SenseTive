using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace ServerLib
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    [Newtonsoft.Json.JsonConverter(typeof(Newtonsoft.Json.Converters.StringEnumConverter))]
    public enum LoginMethod
    {
        /// <summary>
        /// Login method Firebase specifies that Google Firebase is/was used as the login method by an user
        /// </summary>
        Firebase
    }
}
