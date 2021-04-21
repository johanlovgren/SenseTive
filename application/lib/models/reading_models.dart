/// Model containing a reading
class Reading {
  final int id;
  final DateTime date;
  final int durationSeconds;
  final List<int> momHeartRate;
  final List<int> babyHeartRate;
  final List<int> oxygenLevel;
  final List<Contraction> contractions;

  Reading({this.id,
    this.date,
    this.durationSeconds,
    this.momHeartRate,
    this.babyHeartRate,
    this.oxygenLevel,
    this.contractions});

  /// Create a reading from a JSON format
  factory Reading.fromJson(Map<String, dynamic> json) {
    DateTime _date = DateTime.parse(json['date']);
    return Reading(
        id: json['id'],
        date: _date,
        durationSeconds: json['duration'],
        momHeartRate: json['momHeartRate'] == null
            ? null
            : List<int>.from(json['momHeartRate']),
        babyHeartRate: json['babyHeartRate'] == null
            ? null
            : List<int>.from(json['babyHeartRate']),
        oxygenLevel: json['oxygenLevel'] == null
            ? null
            : List<int>.from(json['oxygenLevel']),
        contractions: json['contractions'] == null
            ? null
            : List<Contraction>.from(json['contractions'].map((x) => Contraction.fromJson(x)))
    );
  }

  /// Convert a Reading to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toString(),
    'duration': durationSeconds,
    'momHeartRate': momHeartRate,
    'babyHeartRate': babyHeartRate,
    'oxygenLevel': oxygenLevel,
    'contractions': contractions
  };
}

/// Model containing a contraction reading
class Contraction {
  final String start;
  final String end;
  final String duration;
  final String freq;
  final String intensity;

  Contraction({this.start,
    this.end,
    this.duration,
    this.freq,
    this.intensity});

  /// Create a reading from a JSON format
  factory Contraction.fromJson(Map<String, dynamic> json) =>
      Contraction(
          start: json['start'],
          end: json['end'],
          duration: json['duration'],
          freq: json['freq'],
          intensity: json['intensity']
      );

  /// Convert a Contraction to JSON
  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
    'duration': duration,
    'freq': freq,
    'intensity': intensity
  };
}