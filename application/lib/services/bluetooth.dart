
import 'dart:async';

import 'dart:math';

class BluetoothService {
  Timer _timer;

  StreamController<bool> _bluetoothConnectionController = StreamController<bool>();
  Sink<bool> get _addConnected => _bluetoothConnectionController.sink;
  Stream<bool> get bluetoothConnected => _bluetoothConnectionController.stream;

  StreamController<int> _motherHeartRateController = StreamController<int>();
  Sink<int> get _addMotherHeartRate => _motherHeartRateController.sink;
  Stream<int> get motherHeartRate => _motherHeartRateController.stream;

  StreamController<int> _babyHeartRateController = StreamController<int>();
  Sink<int> get _addBabyHeartRate => _babyHeartRateController.sink;
  Stream<int> get babyHeartRate => _babyHeartRateController.stream;

  BluetoothService() {
    _addConnected.add(true);
  }

  /// Dispose the bluetooth service, closing all streams
  void dispose() {
    if (_timer != null && _timer.isActive)
      _timer.cancel();
    _bluetoothConnectionController.close();
    _motherHeartRateController.close();
    _babyHeartRateController.close();
  }

  /// Starts a measuring session.
  ///
  /// The measuring adds a datapoint to the data stream each second
  /// and will run until [stopMeasuring] is called.
  void startMeasuring() async {
    if (_timer != null && _timer.isActive)
      return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('Measuring');
      _addMotherHeartRate.add(60 +
          (Random().nextBool() ? (-1) : 1) * Random().nextInt(3));
      _addBabyHeartRate.add(140 +
          (Random().nextBool() ? (-1) : 1) * Random().nextInt(3));
    });
  }

  /// Stops a measuring session
  void stopMeasuring() {
    if (_timer.isActive)
      _timer.cancel();
  }
}