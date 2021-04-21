import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sensetive/models/reading_models.dart';

/// File routines used for persistent storage
class DatabaseFileRoutines {
  /// Get the local path to persistent storage
  Future <String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  /// Get the local file containing the stored data
  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/local_persistence.json');
  }

  /// Get stored readings ([Reading]) as JSON
  Future<String> readReadings() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print('File does not exist: ${file.absolute}');
        await writeReadings('{"readings": []}');
      }

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('error readReadings: $e');
      return "";
    }
  }

  /// Write readings ([Reading])to persistent storage
  Future<File> writeReadings(String json) async{
    final file = await _localFile;
    return file.writeAsString('$json');
  }
}

/// Create a [Database] from a JSON
Database databaseFromJson(jsonString) {
  final dataFromJson = json.decode(jsonString);
  return Database.fromJson(dataFromJson);
}

/// Create a JSON from a [Database]
String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

/// Database containing data to be stored in persistent storage
class Database {
  List<Reading> readings;
  Database({
    this.readings
  });

  factory Database.fromJson(Map<String, dynamic> json) =>
      Database(
          readings: List<Reading>.from(json["readings"].map((x) => Reading.fromJson(x)))
      );
  Map<String, dynamic> toJson() => {
    "readings": List<dynamic>.from(readings.map((x) => x.toJson()))
  };
}