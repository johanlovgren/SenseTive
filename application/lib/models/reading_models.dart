/// Model containing a reading
class Reading {
  final DateTime date;
  final int durationSeconds;
  final List<int> heartRate;
  final List<int> oxygenLevel;
  final List<Contraction> contractions;

  Reading({this.date,
      this.durationSeconds,
      this.heartRate,
      this.oxygenLevel,
      this.contractions});

  /// Create a reading from a JSON format
  factory Reading.fromJson(Map<String, dynamic> json) =>
      Reading(
        date: json["date"],
        durationSeconds: json["duration"],
        heartRate: json["heartRate"],
        oxygenLevel: json["oxygenLevel"],
        contractions: json["contractions"]
      );

  /// Convert a Reading to JSON
  Map<String, dynamic> toJson() => {
    "date": date,
    "duration": durationSeconds,
    "heartRate": heartRate,
    "oxygenLevel": oxygenLevel,
    "contractions": contractions
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
        start: json["start"],
        end: json["end"],
        duration: json["duration"],
        freq: json["freq"],
        intensity: json["intensity"]
      );

  /// Convert a Contraction to JSON
  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
    "duration": duration,
    "freq": freq,
    "intensity": intensity
  };
}