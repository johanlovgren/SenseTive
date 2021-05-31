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
        /// <summary>
        /// The GUID of the user associated with this instance
        /// </summary>
        [JsonProperty("sub")]
        public string UserId { get; set; }

        [JsonIgnore]
        public Guid UserGuid
        {
            get => Guid.Parse(UserId);
            set => UserId = value.ToString();
        }

        /// <summary>
        /// The date and time of when the token was issued
        /// </summary>
        [JsonProperty("iat")]
        public long IssueTimeUnix {
            get => new DateTimeOffset(DateTime.SpecifyKind(IssueTime, DateTimeKind.Utc)).ToUnixTimeSeconds();
            set => IssueTime = DateTimeOffset.FromUnixTimeSeconds(value).UtcDateTime;
        }

        [JsonIgnore]
        public DateTime IssueTime { get; set; }

        /// <summary>
        /// The date and time of when the token expires.
        /// If null, the token has no set expiry date.
        /// </summary>
        [JsonProperty("exp")]
        public long? ExpiryTimeEpoch 
        {
            get => ExpiryTime.HasValue
                ? new DateTimeOffset(DateTime.SpecifyKind(ExpiryTime.Value, DateTimeKind.Utc)).ToUnixTimeSeconds()
                : null;
            set => ExpiryTime = value.HasValue
                ? DateTimeOffset.FromUnixTimeSeconds(value.Value).UtcDateTime
                : null;
        }

        [JsonIgnore]
        public DateTime? ExpiryTime { get; set; }

        /// <summary>
        /// The authorization level of the token.
        /// This property specifies the level of privileges the 
        /// token is granted.
        /// </summary>
        public AuthorizationLevel Access { get; set; }

        /// <summary>
        /// Creates a token data instance with given parameters.
        /// 
        /// Note that the time of issue and expiry time is caluclated based on UTC time.
        /// </summary>
        /// <param name="userId">The user ID to associate the token with</param>
        /// <param name="expiry">The timespan after which the token will be regarded as expired.</param>
        /// <param name="authorizationLevel">The authorization level of the token</param>
        /// <returns>A TokenData instance created with the specified parameters</returns>
        public static TokenData Create(Guid userId, TimeSpan expiry, 
            AuthorizationLevel authorizationLevel = AuthorizationLevel.Unauthorized)
        {
            var now = DateTime.UtcNow;
            return new TokenData
            {
                UserId = userId.ToString(),
                IssueTime = now,
                ExpiryTime = now + expiry,
                Access = authorizationLevel
            };
        }

        /// <summary>
        /// Checks whether or not the token has been issued.
        /// This will return false if the issue time of the token is in the future.
        /// 
        /// Note that the time comparison is done in UTC time.
        /// </summary>
        /// <returns>True if the issue time of the token is in the past, false otherwise.</returns>
        public bool HasBeenIssued() => IssueTime < DateTime.UtcNow;

        /// <summary>
        /// Checks whether or not a token has expired
        /// 
        /// Note that the time comparison is done in UTC time.
        /// </summary>
        /// <returns>True if the token has an expiry time and it has been passed, false otherwise</returns>
        public bool IsExpired() => ExpiryTime.HasValue && ExpiryTime.Value <= DateTime.UtcNow;

        /// <summary>
        /// Checks whether or not the time of this token is valid, i.e. if 
        /// it has been issued and not yet expired.
        /// 
        /// Note that time comparisons are done in UTC time.
        /// </summary>
        /// <returns>True if the token has been issued and has not been expired, false otherwise.</returns>
        public bool IsTimeValid() => HasBeenIssued() && !IsExpired();

        /// <summary>
        /// Checks whether or not token is valid and usable.
        /// 
        /// Note that time comparisons are done in UTC time.
        /// </summary>
        /// <returns></returns>
        public bool IsValid() => HasAccess && IsTimeValid();

        /// <summary>
        /// Whether or not the token has a higher authorization level than the unauthorized level
        /// </summary>
        [JsonIgnore]
        public bool HasAccess => Access != AuthorizationLevel.Unauthorized;

        /// <summary>
        /// Whether or not this token has the admin authorization level or higher
        /// </summary>
        [JsonIgnore]
        public bool IsAdmin => Access == AuthorizationLevel.Admin;
    }
}
