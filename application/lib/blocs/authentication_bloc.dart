
/// Interface for a AuthenticationBloc
abstract class AuthenticationBloc {
  /// Sink for adding a JWT token for a logged in user
  Sink<String> get addUser;
  /// Stream for reading a JWT token for a logged in user
  Stream<String> get user;
  /// Sink used for logging out a user, add true for logout
  Sink<bool> get addLogoutUser;
  /// Stream for reading for logout events
  Stream<bool> get listLogoutUser;
}