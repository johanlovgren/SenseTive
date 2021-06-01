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

  /// Upload a reading at the backend
  ///
  /// Throws and Exception on failure
  ///
  /// [jwtToken] The users JWT Token
  /// [reading] The reading to upload
  Future<void> uploadReading({String jwtToken, Reading reading}) async {
    final response = await post(
      Uri.parse(_restApi + _restReading),
      headers: _header..addEntries([MapEntry('Authorization', jwtToken)]),
      body: jsonEncode({
        'readingId': reading.id,
        'duration': reading.durationSeconds,
        'time': reading.date.millisecondsSinceEpoch ~/ 1000,
        'parentHeartRateSamples': _convertHeartRateToServer(reading.date, reading.momHeartRate),
        'childHeartRateSamples': _convertHeartRateToServer(reading.date, reading.babyHeartRate),
        'contractions': null
      })
    );
    if (response.statusCode != 200)
      throw(Exception('Could not upload reading to server: ${response.statusCode}'));
  }

  /// Asks the backend to remove a reading
  ///
  /// Throws an Exception on failure
  ///
  /// [jwtToken] The users JWT Token
  /// [readingId] The id of the reading to be removed
  Future<void> deleteReading({String jwtToken, String readingId}) async {
    final response = await delete(
        Uri.parse(_restApi + _restReading + '/reading?id=' + readingId),
        headers: _header..addEntries([MapEntry('Authorization', jwtToken)])
    );
    if (response.statusCode != 200) {
      throw Exception('Could not delete reading at server: ${response.statusCode}');
    }
  }

  /// Asks the backend for readings
  ///
  /// Throws an Exception on failure, otherwise it returns a List of readings
  ///
  /// [jwtToken] The users JWT Token
  /// [date] If set, asks the server for readings created after [date].
  /// If null, all the users readings are asked for
  Future<List<Reading>> fetchReadings({String jwtToken, DateTime date}) async {
    final response = await get(
      Uri.parse(_restApi + _restReading +
          (date == null
              ? ''
              :'?after=' + (date.millisecondsSinceEpoch ~/ 1000).toString()
              + '&includeHeartRate=true')),
      headers: _header..addEntries([MapEntry('Authorization', jwtToken)]),
    );
    if (response.statusCode != 200)
      throw(Exception('Could not fetch readings from server: ${response.statusCode}'));

    List<dynamic> responseBody = json.decode(response.body);
    List<Reading> readings = List.from(responseBody.map((r) => Reading(
        id: r['readingId'],
        durationSeconds: r['duration'],
        date: DateTime.fromMillisecondsSinceEpoch(r['time'] * 1000),
        momHeartRate: _convertHeartRateFromServer(r['parentHeartRateSamples']),
        babyHeartRate: _convertHeartRateFromServer(r['childHeartRateSamples']),
        // Implement when server supports
        contractions: null
    )));
    return readings;
  }

  /// Convert the heart rate format received from the server
  List<int> _convertHeartRateFromServer(List<dynamic> readings) {
    return List<int>.from(readings.map((r) => r['heartRate']));
  }
  /// Converts the heart rate format to the server format
  List<Map<String, int>> _convertHeartRateToServer(DateTime date, List<int> heartRate) {
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

