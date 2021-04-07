using Newtonsoft.Json;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Authentication
{
    public class TokenData
    {
        [JsonProperty("sub")]
        public string UserId { get; set; }

        [JsonProperty("iat")]
        public DateTime IssueTime { get; set; }

        [JsonProperty("exp")]
        public DateTime? ExpiryTime { get; set; }

        public bool HasBeenIssued() => IssueTime > DateTime.UtcNow;
        public bool IsExpired() => ExpiryTime.HasValue && ExpiryTime.Value <= DateTime.UtcNow;

        public bool IsTimeValid() => HasBeenIssued() && !IsExpired();

        public bool IsValid() => HasAccess && IsTimeValid();

        public AuthorizationLevel Access { get; }

        public bool HasAccess => Access != AuthorizationLevel.Unauthorized;
        public bool IsAdmin => Access == AuthorizationLevel.Admin;
    }
}
