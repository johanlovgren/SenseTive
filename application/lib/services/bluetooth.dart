
import 'dart:async';

class BluetoothService {
  StreamController<bool> _bluetoothConnectionController = StreamController<bool>();
  Sink<bool> get _addConnected => _bluetoothConnectionController.sink;
  Stream<bool> get bluetoothConnected => _bluetoothConnectionController.stream;

  StreamController<int> _motherHeartRateController = StreamController<int>();
  Sink<int> get _addMotherHeartRate => _motherHeartRateController.sink;
  Stream<int> get motherHeartRate => _motherHeartRateController.stream;

  StreamController<int> _babyHeartRateController = StreamController<int>();
  Sink<int> get _addBabyHeartRate => _babyHeartRateController.sink;
  Stream<int> get babyHeartRate => _babyHeartRateController.stream;


  void startMeasuring() {
    // TODO Implement this as a dummy
  }
}