import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/backend.dart';
import 'package:sensetive/services/backend_api.dart';
import 'package:sensetive/services/bluetooth.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';
import 'package:sensetive/widgets/timer_actions.dart';
import 'package:uuid/uuid.dart';

/// BLoC for performing measurements
///
/// [_databaseFileRoutines]
/// [_readingsDatabase]
/// [_backendApi]
/// [timerBloc] BLoC that controlls the timer
/// [_bluetoothService] the bluetooth service being used that provides the measurements

class MeasuringBloc {
  DatabaseFileRoutines _databaseFileRoutines;
  ReadingsDatabase _readingsDatabase;
  final String jwt;

  final TimerBloc timerBloc;
  final BackendApi _backendApi = BackendService();
  final BluetoothService _bluetoothService = BluetoothService();
  final List<int> _motherHeartRates = [];
  final List<int> _babyHeartRates = [];

  /// Stream for checking actions performed to the timer
  final StreamController<int> _timerEventController = StreamController<int>();
  Sink<int> get addTimerEvent => _timerEventController.sink;
  Stream<int> get timerEvent => _timerEventController.stream;

  MeasuringBloc({@required this.timerBloc, @required this.jwt}) {
    _init();
  }

  /// Initializing the different services and controllers used for collecting
  /// a measurement
  void _init() async {
    //animationController = AnimationController(vsync: 0,duration: Duration(seconds: 2));
    _databaseFileRoutines = DatabaseFileRoutines(uid: DecodedJwt(jwt: jwt).uid);
    _bluetoothService.motherHeartRate.listen((heartRate) {
      _addHeartRate(heartRate, _motherHeartRates);
      print(_motherHeartRates);
    });
    _bluetoothService.babyHeartRate.listen((heartRate) {
      _addHeartRate(heartRate, _babyHeartRates);
      print(_babyHeartRates);
    });
    timerEvent.listen((event) {
      switch (event) {
        case TimerEvents.start:
          _bluetoothService.startMeasuring();
          break;
        case TimerEvents.pause:
          _bluetoothService.stopMeasuring();
          break;
        case TimerEvents.stop:
          _bluetoothService.stopMeasuring();
          completeReading(timerBloc.getCurrentDuration());
          break;
      }
    });
  }

  /// Adds a heart rate to a list of heartrates
  void _addHeartRate(int heartRate, List<int> heartRates) {
    heartRates.add(heartRate);
  }

  /// Get the heart rates of the mother
  List<int> getMotherHeartRates() {
    return _motherHeartRates;
  }

  /// Get the heart rates of the baby
  List<int> getBabyHeartRates() {
    return _babyHeartRates;
  }

  /// Stores the [reading] in the users local database and to the remote database
  Future<void> _storeReading(Reading reading) async {
    // Store reading locally
    _readingsDatabase =
        readingsDatabaseFromJson(await _databaseFileRoutines.readReadings());
    _readingsDatabase.readings.add(reading);
    await _databaseFileRoutines
        .writeReadings(databaseToJson(_readingsDatabase));

    // Store reading remote
    _backendApi
        .uploadReading(jwtToken: jwt, reading: reading)
        .catchError((error) {
      // TODO handle error
      print(error.message);
    });
  }

  /// Completes the [Reading] currently being measured
  void completeReading(int duration) async {
    Reading newReading = Reading(
        id: Uuid().v4(),
        date: DateTime.now().subtract(Duration(seconds: duration)).toUtc(),
        durationSeconds: duration,
        momHeartRate: _motherHeartRates,
        babyHeartRate: _babyHeartRates,
        oxygenLevel: null,
        contractions: null);

    await _storeReading(newReading);

    _motherHeartRates.clear();
    _babyHeartRates.clear();
  }

  /// Closes the the controllers and BLoC´s being used
  void dispose() {
    timerBloc.close();
    _timerEventController.close();
    _bluetoothService.dispose();
  }
}
