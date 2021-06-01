import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return File('$path/$uid.readings.json');
  }

  /// Get local file containing stored user data
  Future<File> get _localUserFile async {
    final path = await _localPath;
    return File('$path/$uid.user.json');
  }

  /// Writes a profile picture for the current user
  ///
  /// [picture] The picture to copy
  Future <void> writeProfileImage(File picture) async {
    final path = await _localPath;
    await picture.copy('$path/$uid.png');
  }

  /// Reads the profile picture for the current user
  ///
  /// Returns the profile picture or null if it doesn't exist
  Future<File> get profileImageFile async {
    try {
      final path = await _localPath;
      final image = File('$path/$uid.png');
      return !image.existsSync() ? null : image;
    } catch (e) {
      print('error readProfilePicture: $e');
      return null;
    }
  }

  /// Removes all files associated to the current user
  Future<bool> deleteAllData() async {
    final profileImage = await profileImageFile;
    if (profileImage != null)
      profileImage.delete();
    final userFile = await _localUserFile;
    if (userFile.existsSync())
      userFile.delete();
    final readingsFile = await _localReadingsFile;
    if (readingsFile.existsSync())
      readingsFile.delete();
    return true;
  }

  /// Get stored user data as JSON
  Future<String> readUserData() async{
    try {
      final file = await _localUserFile;
      if (!file.existsSync()) {
        print('File does not exist: ${file.absolute}');
        await writeUserData('{"name": "","email":"", "profilePicturePath":""}');
      }

      return await file.readAsString();
    } catch (e) {
      print('error readUserData: $e');
      return '';
    }
  }
  /// Write user data to persistent storage
  ///
  /// [json] userdata in JSON format
  Future<File> writeUserData(String json) async {
    final file = await _localUserFile;
    return file.writeAsString('$json');
  }


  /// Get stored readings ([Reading]) as JSON
  Future<String> readReadings() async {
    try {
      final file = await _localReadingsFile;
      if (!file.existsSync()) {
        print('File does not exist: ${file.absolute}');
        await writeReadings(ReadingsDatabase.emptyTemplate);
      }

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('error readReadings: $e');
      return '';
    }
  }

  /// Write readings ([Reading])to persistent storage
  ///
  /// [json] Readings in JSON format
  Future<File> writeReadings(String json) async{
    final file = await _localReadingsFile;
    return file.writeAsString('$json');
  }
}

/// Create a [ReadingsDatabase] from a JSON
ReadingsDatabase readingsDatabaseFromJson(jsonString) =>
    ReadingsDatabase.fromJson(json.decode(jsonString));

/// Create a [UserDatabase] from JSON
UserDatabase userDatabaseFromJson(jsonString) =>
    UserDatabase.fromJson(json.decode(jsonString));


/// Create a JSON from a [ReadingsDatabase]
String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

abstract class Database {
  Map<String, dynamic> toJson();
}

class UserDatabase extends Database {
  String name;
  String email;
  UserDatabase({this.name, this.email});

  factory UserDatabase.fromJson(Map<String, dynamic> json) =>
      UserDatabase(
        name: json['name'],
        email: json['email'],
      );

  /// Returns the database as JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
  };
}


/// Database containing data to be stored in persistent storage
class ReadingsDatabase extends Database {
  static const emptyTemplate = '{"readings": [], "updatedAt": null}';
  List<Reading> readings;
  DateTime updatedAt;
  ReadingsDatabase({this.readings, this.updatedAt});

  factory ReadingsDatabase.fromJson(Map<String, dynamic> json) =>
      ReadingsDatabase(
          readings: List<Reading>.from(json["readings"].map((x) => Reading.fromJson(x))),
          updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']): null
      );

  /// Returns the database as JSON
  Map<String, dynamic> toJson() => {
    "readings": List<dynamic>.from(readings.map((x) => x.toJson())),
    'updatedAt': updatedAt != null ? updatedAt.toString() : null
  };
}