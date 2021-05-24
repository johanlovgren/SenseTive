import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/bluetooth.dart';
import 'package:sensetive/widgets/timer_actions.dart';

class MeasuringBloc {
  final timerBloc;
  final BluetoothService _bluetoothService = BluetoothService();
  final List<int> _motherHeartRates = [];
  final List<int> _babyHeartRates = [];
  final DateTime _date = DateTime.now();


  final StreamController<int> _timerEventController = StreamController<int>();
  Sink<int> get addTimerEvent => _timerEventController.sink;
  Stream<int> get timerEvent => _timerEventController.stream;

  MeasuringBloc({@required this.timerBloc}) {
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
          // TODO Implement this
          break;
        case TimerEvents.pause:
        // TODO Implement this
          break;
        case TimerEvents.stop:
        // TODO Implement this
          break;
      }
      // TODO Fix this
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

  Reading completeReading(int duration) {
    Reading newReading = Reading(
        id: 1,
        date: DateTime.now().subtract(Duration(seconds: duration)),
        durationSeconds: duration,
        momHeartRate: getMotherHeartRates(),
        babyHeartRate: getBabyHeartRates(),
        oxygenLevel: null,
        contractions: null);
    // TODO Store reading in database


    _motherHeartRates.clear();
    _babyHeartRates.clear();
    return newReading;
  }

  void dispose() {
    _timerEventController.close();
  }
}
