import 'package:flutter/material.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/database.dart';
import 'dart:math';

class DatabaseExample extends StatefulWidget {
  @override
  _DatabaseExampleState createState() => _DatabaseExampleState();
}

class _DatabaseExampleState extends State<DatabaseExample> {
  Database _readingDatabase;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.add),
        color: Colors.red,
        iconSize: 50,
        onPressed: () async {
          if (_readingDatabase == null) {
            await DatabaseFileRoutines().readReadings().then((readingsJson) {
              _readingDatabase = databaseFromJson(readingsJson);
            });
          }
          _readingDatabase.readings.add(dummyReading());
          DatabaseFileRoutines().writeReadings(databaseToJson(_readingDatabase));
        },
      ),
    );
  }

  Reading dummyReading() {
    return Reading(
      // Fix better solution for ID's
      id: Random().nextInt(2^32),
      date: DateTime.now(),
      durationSeconds: 60 + Random().nextInt(60*60-200),
      momHeartRate: [60,62,64,61,57,60,60,62,64,61,57,60,60,62,64,61,57,60,60,62,64,61,57,60],
      babyHeartRate: [60,62,64,61,57,60,60,62,64,61,57,60,60,62,64,61,57,60,60,62,64,61,57,60],
      oxygenLevel: null,
      contractions: null
    );
  }
}

