import 'package:flutter/material.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/database.dart';
import 'dart:math';

import 'package:sensetive/utils/jwt_decoder.dart';
import 'package:uuid/uuid.dart';

class DatabaseExample extends StatefulWidget {
  @override
  _DatabaseExampleState createState() => _DatabaseExampleState();
}

class _DatabaseExampleState extends State<DatabaseExample> {
  ReadingsDatabase _readingDatabase;
  String _uid;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _uid = DecodedJwt(jwt: HomeBlocProvider.of(context).jwt).uid;
    return Container(
      child: IconButton(
        icon: Icon(Icons.add),
        color: Colors.red,
        iconSize: 50,
        onPressed: () async {
          if (_readingDatabase == null) {
            await DatabaseFileRoutines(uid: _uid).readReadings().then((readingsJson) {
              _readingDatabase = readingsDatabaseFromJson(readingsJson);
            });
          }
          _readingDatabase.readings.add(dummyReading());
          DatabaseFileRoutines(uid: _uid).writeReadings(databaseToJson(_readingDatabase));
        },
      ),
    );
  }

  Reading dummyReading() {
    int duration = 60 + Random().nextInt(60*60-200);
    return Reading(
      // Fix better solution for ID's
        id: Uuid().v4(),
        date: DateTime.now().subtract(Duration(days: Random().nextInt(30))),
        durationSeconds: duration,
        momHeartRate: _momRandomHeartRate(duration),
        babyHeartRate: _babyRandomHeartRate(duration),
        oxygenLevel: null,
        contractions: null
    );
  }

  List<int> _momRandomHeartRate(int duration) {
    List<int> heartRate = [];
    for (int i = 0; i < duration / 60; i++) {
      heartRate.add(55 + (Random().nextBool() ? 1 : -1) * Random().nextInt(2));
    }
    return heartRate;
  }

  List<int> _babyRandomHeartRate(int duration) {
    List<int> heartRate = [];
    for (int i = 0; i < duration / 60; i++) {
      heartRate.add(140 + (Random().nextBool() ? 1 : -1) * Random().nextInt(2));
    }
    return heartRate;
  }
}

