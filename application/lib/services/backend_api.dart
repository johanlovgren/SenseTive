import 'package:sensetive/models/reading_models.dart';

/// Interface that the backend service must implement
abstract class BackendApi {
  Future<String> signIn({String method, String token});
  Future<bool> deleteAccount({String jwtToken});
  Future<void> uploadReading({String jwtToken, Reading reading});
  Future<List<Reading>> fetchReadings({String jwtToken, DateTime date});
  Future<void> deleteReading({String jwtToken, String readingId});
}

/// Login event
///
/// [method] what external method used to sign in
/// [token] received from the external method
class LoginEvent {
  final String method;
  final String token;
  LoginEvent({this.method, this.token});
}