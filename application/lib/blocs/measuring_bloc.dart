import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/backend.dart';
import 'package:sensetive/services/backend_api.dart';
import 'package:sensetive/services/bluetooth.dart';
import 'package:sensetive/services/database.dart';
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
  BackendApi _backendApi;
  final String uid;
  final TimerBloc timerBloc;
  final BluetoothService _bluetoothService = BluetoothService();
  final List<int> _motherHeartRates = [];
  final List<int> _babyHeartRates = [];

  /// Stream for checking actions performed to the timer
  final StreamController<int> _timerEventController = StreamController<int>();
  Sink<int> get addTimerEvent => _timerEventController.sink;
  Stream<int> get timerEvent => _timerEventController.stream;

  /// Constructing the measuring bLoC
  MeasuringBloc({@required this.timerBloc, @required this.uid}) {
    _init();
  }

  /// Initializing the different services and controllers used for collecting
  /// a measurement
  void _init() async {
    _backendApi = BackendService();
    _databaseFileRoutines = DatabaseFileRoutines(uid: uid);
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

  /// Adds a heartrate to a list of heartrates
  void _addHeartRate(int heartRate, List<int> heartRates) {
    heartRates.add(heartRate);
  }

  /// Get the heartrates of the mother
  List<int> getMotherHeartRates() {
    return _motherHeartRates;
  }

  /// Get the heartrates of the baby
  List<int> getBabyHeartRates() {
    return _babyHeartRates;
  }

  /// Stores the [reading] in the users local database and to the remote database
  Future<void> _storeReading(Reading reading) async {
    // Store reading locally
    if (_readingsDatabase == null) {
      _readingsDatabase =
          readingsDatabaseFromJson(await _databaseFileRoutines.readReadings());
    }
    _readingsDatabase.readings.add(reading);
    await _databaseFileRoutines
        .writeReadings(databaseToJson(_readingsDatabase));

    // Store reading remote
    _backendApi
        .uploadReading(jwtToken: null, reading: reading)
        .catchError((error) {
      // TODO handle error
      print(error.message);
    });
  }

  /// Completes the [Reading] currently being measured
  void completeReading(int duration) async {
    Reading newReading = Reading(
        id: Uuid().v4(),
        date: DateTime.now().subtract(Duration(seconds: duration)),
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
  }
}
