using rDB;
using rDB.Attributes;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    [DatabaseTable("reading")]
    public class DbReading : DatabaseEntry
    {
        [DatabaseColumn("VARCHAR(36)", IsPrimaryKey = true)]
        public string ReadingId { get; set; }

        [ForeignKey(typeof(DbUser), nameof(DbUser.UserId), OnDelete = ForeignKeyAttribute.ReferenceOption.Cascade)]
        [DatabaseColumn("VARCHAR(36)", IsPrimaryKey = true)]
        public string OwnerId { get; set; }

        [DatabaseColumn("TIMESTAMP", NotNull = true)]
        public DateTime Time { get; set; }

        [DatabaseColumn("DOUBLE", NotNull = true)]
        public double Duration { get; set; }
    }
}
