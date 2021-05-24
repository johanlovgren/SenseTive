import 'package:sensetive/models/reading_models.dart';
import 'package:sensetive/services/bluetooth.dart';

class MeasuringBloc {
  final BluetoothService _bluetoothService = BluetoothService();
  final List<int> _motherHeartRates = [];
  final List<int> _babyHeartRates = [];
  final DateTime _date = DateTime.now();

  MeasuringBloc() {
    _bluetoothService.motherHeartRate.listen((heartRate) {
      _addHeartRate(heartRate, _motherHeartRates);
      print(_motherHeartRates);
    });
    _bluetoothService.babyHeartRate.listen((heartRate) {
      _addHeartRate(heartRate, _babyHeartRates);
      print(_babyHeartRates);
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
    return Reading(
        id: 1,
        durationSeconds: duration,
        momHeartRate: getMotherHeartRates(),
        babyHeartRate: getBabyHeartRates(),
        oxygenLevel: null,
        contractions: null);
  }

  //TODO: Implement the dispose function
  void dispose() {}
}
