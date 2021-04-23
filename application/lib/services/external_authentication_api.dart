import 'backend_api.dart';

/// Interface for external authentication API
abstract class ExternalAuthenticationApi {
  /// Sink for adding an authenticated user that is to be signed in by the
  /// backend service
  Sink<LoginEvent> get addLoginUser;
  /// Stream for reading an authenticated user that is to be signed in by the
  /// backend service
  Stream<LoginEvent> get loginUser;
  /// Sink for adding a login error
  Sink<String> get addLoginError;
  /// Stream for reading a login error
  Stream<String> get loginError;
  /// Sign out the user with the external authentication method
  Future<void> signOut();
  /// Sign in the user with the external authentication method
  Future<void> signIn();
}