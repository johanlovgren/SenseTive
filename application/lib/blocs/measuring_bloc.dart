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
    });
    _bluetoothService.babyHeartRate.listen((heartRate) {
      _addHeartRate(heartRate, _babyHeartRates);
    });
  }

  void _addHeartRate(int heartRate, List<int> heartRates) {
    heartRates.add(heartRate);
  }

  //TODO: Implement the dispose function
  void dispose() {}
}
