import 'dart:convert';
import 'package:sensetive/models/reading_models.dart';

import 'backend_api.dart';
import 'package:http/http.dart';

/// Backend service used to communicate with the backend
class BackendService implements BackendApi {
  final String _restApi = 'https://rickebo.com/sensetive';
  final String _restAccount = '/account';
  final String _restReading = '/reading';
  final Map<String, String> _header = {
    'Content-Type': 'application/json',
    'Accept-Encoding': '',
    'Charset': 'utf-8'
  };

  /// Sign in the current user with a supported method by the backend
  /// On error, exception is thrown
  ///
  /// [method] what method to sign in with, were the token is received
  /// [token] the token received by the chosen method
  @override
  Future<String> signIn({String method, String token}) async {
    final response = await post(
        Uri.parse(_restApi + '/login'),
        body: jsonEncode({
          "Method": method,
          "Identifier": token
        }),
        headers: _header);

    if (response.statusCode == 200) {
      String jwtToken = jsonDecode(response.body)['token'];
      return jwtToken;
    } else {
      throw(Exception('Server connection error: ${response.statusCode}'));
    }
  }

  /// Asks the backend to delete the current users account
  ///
  /// [jwtToken] the users JWT token
  Future<bool> deleteAccount({String jwtToken}) async {
    final response = await delete(
      Uri.parse(_restApi + _restAccount),
      headers: _header..addEntries([MapEntry('Authorization', jwtToken)]));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw(Exception('Server connection error: ${response.statusCode}'));
    }
  }

  Future<void> uploadReading({String jwtToken, Reading reading}) async {
    final response = await post(
      Uri.parse(_restApi + _restReading),
      headers: _header..addEntries([MapEntry('Authorization', jwtToken)]),
      body: jsonEncode({
        'readingId': reading.id,
        'duration': reading.durationSeconds,
        'time': reading.date.millisecondsSinceEpoch ~/ 1000,
        'parentHeartRateSamples': _convertHeartRate(reading.date, reading.momHeartRate),
        'childHeartRateSamples': _convertHeartRate(reading.date, reading.babyHeartRate),
        'contractions': null
      })
    );
    if (response.statusCode != 200)
      throw(Exception('Could not upload reading to server: ${response.statusCode}'));

  }

  List<Map<String, int>> _convertHeartRate(DateTime date, List<int> heartRate) {
    int index = 0;
    int secondsSinceEpoc = date.millisecondsSinceEpoch ~/ 1000;
    return List.from(heartRate.map((x)
      => {
        'time': secondsSinceEpoc + index++,
        'heartRate': x
      }
    ));
  }
}

