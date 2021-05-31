using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

using rDB;

using ServerLib.Data;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

using static ServerLib.Data.DbNumericReadingEntry;

namespace WebAPI.Controllers
{
    [JwtAuthorize]
    [Route("[controller]")]
    [ApiController]
    public class ReadingController : Controller
    {
        private readonly UserService _userService;
        private readonly Database _database;

        public ReadingController(Database database, UserService userSerivice)
        {
            _userService = userSerivice;
            _database = database;
        }
        
        [HttpGet]
        public async Task<IActionResult> Get(string id = null, long? after = null, bool includeHeartRate = true, bool includeContractions = true)
        {
            var user = await _userService.GetUser(HttpContext)
                .ConfigureAwait(false);

            if (user == null)
                return BadRequest();

            Guid parsedId = default;
            if (id != null && !Guid.TryParse(id, out parsedId))
                return BadRequest();

            if (after.HasValue && after.Value < 0)
                return BadRequest();

            await using var table = await _database.Table<DbReading>()
                .ConfigureAwait(false);

            var queryProcessor = new QueryProcessor(query => query
                .Where(nameof(DbReading.OwnerId), "=", user.UserId));

            if (id != null)
                queryProcessor += new QueryProcessor(query => query
                    .Where(nameof(DbReading.ReadingId), "=", parsedId.ToString()));

            if (after.HasValue)
                queryProcessor += new QueryProcessor(query => query
                    .Where(nameof(DbReading.Time), ">", DateTimeOffset.FromUnixTimeSeconds(after.Value).UtcDateTime));

            var readings = await table.Select(queryProcessor)
                .ConfigureAwait(false);

            if (readings == null || !readings.Any())
                return NotFound();

            return Ok(await Task.WhenAll(readings.Select(async reading =>
            {
                var localTable = await _database.Table<DbNumericReadingEntry>()
                    .ConfigureAwait(false);

                var readingEntries = includeHeartRate 
                    ? await localTable.Table<DbNumericReadingEntry>().Select(query => query
                        .Where(nameof(DbNumericReadingEntry.OwnerId), "=", reading.OwnerId)
                        .Where(nameof(DbNumericReadingEntry.ReadingId), "=", reading.ReadingId))
                        .ConfigureAwait(false)
                    : null;

                var parentHeartRateSamples = readingEntries?.Where(entry => 
                    entry.ReadingType == DbNumericReadingEntry.NumericReadingEntryType.ParentHeartrate);

                var childHeartRateSamples = readingEntries?.Where(entry => 
                    entry.ReadingType == DbNumericReadingEntry.NumericReadingEntryType.ChildHeartrate);

                var ret =  new Reading
                {
                    Duration = reading.Duration,
                    DateTime = reading.Time,
                    ReadingId = reading.ReadingId,
                    ParentHeartRateSamples = parentHeartRateSamples?.Select(sample => new HeartRateEntry(sample)),
                    ChildHeartRateSamples = childHeartRateSamples?.Select(sample => new HeartRateEntry(sample)),
                };

                var time = ret.Time;

                return ret;
            })).ConfigureAwait(false));
        }
        
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Reading reading)
        {
            var user = await _userService.GetUser(HttpContext)
                .ConfigureAwait(false);

            if (user == null)
                return BadRequest();

            await using var table = await _database.Table<DbReading>()
                .ConfigureAwait(false);

            var readingStringId = reading.ReadingGuid.ToString();

            var existingEntry = await table.SelectFirstOrDefault(query => query
                .Where(nameof(DbReading.ReadingId), "=", readingStringId)
                .Where(nameof(DbReading.OwnerId), "=", user.UserId))
                .ConfigureAwait(false);

            if (existingEntry != null)
                return Conflict();

            var insertedCount = await table.Insert(new DbReading()
            {
                OwnerId = user.UserId,
                Time = reading.DateTime,
                Duration = reading.Duration,
                ReadingId = readingStringId
            }).ConfigureAwait(false);

            if (insertedCount <= 0)
                return StatusCode(500);

            var readingIndex = 1;
            var readingConverter = new Func<HeartRateEntry, NumericReadingEntryType, DbNumericReadingEntry>(
                (entry, type) => new DbNumericReadingEntry()
            {
                HeartRate = entry.HeartRate,
                Time = entry.DateTime,
                ReadingType = type,
                ReadingId = readingStringId,
                OwnerId = user.UserId,
                EntryId = readingIndex++
            });

            var parentRate = reading.ParentHeartRateSamples?
                .Select(entry => readingConverter(entry, NumericReadingEntryType.ParentHeartrate)) 
                ?? Enumerable.Empty<DbNumericReadingEntry>();
            
            var childRate = reading.ChildHeartRateSamples?
                .Select(entry => readingConverter(entry, NumericReadingEntryType.ChildHeartrate)) 
                ?? Enumerable.Empty<DbNumericReadingEntry>();

            var heartRateEntries = parentRate.Concat(childRate);

            foreach (var entry in heartRateEntries)
                await table.Table<DbNumericReadingEntry>()
                    .Insert(entry)
                    .ConfigureAwait(false);

            return Ok();
        }


        [HttpDelete]
        public async Task<IActionResult> Delete(string id)
        {
            var user = await _userService.GetUser(HttpContext)
                .ConfigureAwait(false);

            if (user == null)
                return BadRequest();

            if (!Guid.TryParse(id, out var guid))
                return BadRequest();

            await using var table = await _database.Table<DbReading>()
                .ConfigureAwait(false);

            var deleted = await table.Delete(query => query
                .Where(nameof(DbReading.ReadingId), "=", guid.ToString())
                .Where(nameof(DbReading.OwnerId), "=", user.UserId))
                .ConfigureAwait(false);

            return deleted > 0
                ? Ok()
                : NotFound();
        }

        public class Reading
        {
            public double Duration { get; set; }

            [JsonIgnore]
            public DateTime DateTime { get; set; }

            public string ReadingId 
            { 
                get => ReadingGuid.ToString(); 
                set => ReadingGuid = Guid.Parse(value);
            }

            public long Time
            {
                get => new DateTimeOffset(DateTime.SpecifyKind(DateTime, DateTimeKind.Utc)).ToUnixTimeSeconds();
                set => DateTime = DateTimeOffset.FromUnixTimeSeconds(value).UtcDateTime;
            }

            [JsonIgnore]
            public Guid ReadingGuid { get; set; }

            public IEnumerable<HeartRateEntry> ParentHeartRateSamples { get; set; }
            public IEnumerable<HeartRateEntry> ChildHeartRateSamples { get; set; }
            public IEnumerable<Contraction> Contractions { get; set; }
        }

        public class HeartRateEntry
        {
            [JsonIgnore]
            public DateTime DateTime { get; set; }

            public long Time
            {
                get => new DateTimeOffset(DateTime.SpecifyKind(DateTime, DateTimeKind.Utc)).ToUnixTimeSeconds();
                set => DateTime = DateTimeOffset.FromUnixTimeSeconds(value).UtcDateTime;
            }

            public double HeartRate { get; set; }

            public HeartRateEntry(DbNumericReadingEntry dbEntry)
            {
                DateTime = dbEntry.Time;
                HeartRate = dbEntry.HeartRate;
            }

            public HeartRateEntry()
            {

            }
        }

        public class Contraction
        {

        }
    }
}
