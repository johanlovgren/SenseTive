import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sensetive/models/reading_models.dart';

class DatabaseFileRoutines {
  Future <String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/local_persistence.json');
  }

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

  Future<File> writeReadings(String json) async{
    final file = await _localFile;
    return file.writeAsString('$json');
  }
}

Database databaseFromJson(jsonString) {
  final dataFromJson = json.decode(jsonString);
  return Database.fromJson(dataFromJson);
}

String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

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