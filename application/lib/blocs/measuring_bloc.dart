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

class MeasuringBloc {
  DatabaseFileRoutines _databaseFileRoutines;
  ReadingsDatabase _readingsDatabase;
  BackendApi _backendApi;
  final String uid;

  final TimerBloc timerBloc;
  final BluetoothService _bluetoothService = BluetoothService();
  final List<int> _motherHeartRates = [];
  final List<int> _babyHeartRates = [];

  final StreamController<int> _timerEventController = StreamController<int>();
  Sink<int> get addTimerEvent => _timerEventController.sink;
  Stream<int> get timerEvent => _timerEventController.stream;

  MeasuringBloc({@required this.timerBloc, @required this.uid}) {
    _init();
  }

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
      switch (event){
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
  void _addHeartRate(int heartRate, List<int> heartRates) {
    heartRates.add(heartRate);
  }

  List<int> getMotherHeartRates() {
    return _motherHeartRates;
  }

  List<int> getBabyHeartRates() {
    return _babyHeartRates;
  }

  Future<void> _storeReading(Reading reading) async {
    // Store reading locally
    _readingsDatabase = readingsDatabaseFromJson(await _databaseFileRoutines.readReadings());
    _readingsDatabase.readings.add(reading);
    await _databaseFileRoutines.writeReadings(databaseToJson(_readingsDatabase));

    // Store reading remote
    _backendApi.uploadReading(jwtToken: null, reading: reading)
        .catchError((error) {
      // TODO handle error
      print(error.message);
    });
  }

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

  void dispose() {
    timerBloc.close();
    _timerEventController.close();
  }
}
