import 'package:flutter/material.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/database.dart';
import 'dart:math';

import 'package:sensetive/utils/jwt_decoder.dart';

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

