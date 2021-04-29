import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sensetive/models/reading_models.dart';

/// File routines used for persistent storage
class DatabaseFileRoutines {
  final String uid;

  DatabaseFileRoutines({@required this.uid});

  /// Get the local path to persistent storage
  Future <String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  /// Get the local file containing the stored data
  Future<File> get _localReadingsFile async {
    final path = await _localPath;
    return File('$path/$uid.json');
  }

  /// Get stored readings ([Reading]) as JSON
  Future<String> readReadings() async {
    try {
      final file = await _localReadingsFile;
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
    final file = await _localReadingsFile;
    return file.writeAsString('$json');
  }
}

/// Create a [ReadingsDatabase] from a JSON
ReadingsDatabase databaseFromJson(jsonString) {
  final dataFromJson = json.decode(jsonString);
  return ReadingsDatabase.fromJson(dataFromJson);
}

/// Create a JSON from a [ReadingsDatabase]
String databaseToJson(ReadingsDatabase data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

/// Database containing data to be stored in persistent storage
class ReadingsDatabase {
  List<Reading> readings;
  ReadingsDatabase({this.readings});

  factory ReadingsDatabase.fromJson(Map<String, dynamic> json) =>
      ReadingsDatabase(
          readings: List<Reading>.from(json["readings"].map((x) => Reading.fromJson(x)))
      );
  Map<String, dynamic> toJson() => {
    "readings": List<dynamic>.from(readings.map((x) => x.toJson()))
  };
}