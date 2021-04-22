/// Interface that the backend service must implement
abstract class BackendApi {
  Future<String> signIn({String method, String token});
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