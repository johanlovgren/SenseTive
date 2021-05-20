import 'package:intl/intl.dart';

/// Model containing a reading
class Reading {
  final int id;
  final DateTime date;
  final int durationSeconds;
  final List<int> momHeartRate;
  int momAvgHeartRate;
  final List<int> babyHeartRate;
  int babyAvgHeartRate;
  final List<int> oxygenLevel;
  final List<Contraction> contractions;

  Reading({this.id,
    this.date,
    this.durationSeconds,
    this.momHeartRate,
    this.babyHeartRate,
    this.oxygenLevel,
    this.contractions}) {
    momAvgHeartRate = momHeartRate != null
        ? (momHeartRate.reduce((a, b) => a+b) / momHeartRate.length).round()
        : null;
    babyAvgHeartRate = babyHeartRate != null
        ? (babyHeartRate.reduce((a, b) => a+b) / babyHeartRate.length).round()
        : null;
  }


  @override
  String toString() {
    return '${DateFormat.yMMMd().add_Hm().format(date)}';
  }


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


String durationToString(int durationSeconds) {
  int hours = (durationSeconds ~/ (60 * 60));
  int minutes = (durationSeconds - hours * (60 * 60)) ~/ 60;
  int seconds = (durationSeconds - hours * (60 * 60) - minutes * 60);
  return (hours > 0 ? '$hours:' : '') + '$minutes:' + '$seconds';
}