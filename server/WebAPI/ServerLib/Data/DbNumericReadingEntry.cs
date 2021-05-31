using rDB;
using rDB.Attributes;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerLib.Data
{
    [DatabaseTable("reading_entry")]
    public class DbNumericReadingEntry : DatabaseEntry
    {
        [ForeignKey(typeof(DbReading), nameof(DbReading.OwnerId), nameof(DbReading.ReadingId), OnDelete = ForeignKeyAttribute.ReferenceOption.Cascade)]
        [DatabaseColumn("VARCHAR(36)", IsPrimaryKey = true)]
        public string OwnerId { get; set; }

        [ForeignKey(typeof(DbReading), nameof(DbReading.OwnerId), nameof(DbReading.ReadingId), OnDelete = ForeignKeyAttribute.ReferenceOption.Cascade)]
        [DatabaseColumn("VARCHAR(36)", IsPrimaryKey = true)]
        public string ReadingId { get; set; }

        [DatabaseColumn("INT", IsPrimaryKey = true)]
        public int EntryId { get; set; }

        [DatabaseColumn("DOUBLE", NotNull = true)]
        public double HeartRate { get; set; }

        [DatabaseColumn("TIMESTAMP", NotNull = true)]
        public DateTime Time { get; set; }

        [DatabaseColumn("INT", NotNull = true)]
        public int Type { get; set; }

        public NumericReadingEntryType ReadingType
        {
            get => (NumericReadingEntryType) Type;
            set => Type = (int) value;
        }

        public enum NumericReadingEntryType
        {
            ParentHeartrate,
            ChildHeartrate,
            OxygenLevel
        }
    }
}
