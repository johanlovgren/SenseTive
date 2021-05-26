import 'dart:async';
import 'package:sensetive/blocs/authentication_bloc.dart';
import 'package:sensetive/services/firebase_authentication_api.dart';

/// Authentication BLoC for Firebase
///
/// [authenticationApi] is the [FirebaseAuthenticationApi] to be used
class FirebaseAuthenticationBloc implements AuthenticationBloc {
  final FirebaseAuthenticationApi authenticationApi;

  /// Stream controller authenticated user
  final StreamController<String> _authenticationController = StreamController<String>();
  /// Sink for adding the authenticated users UID/token
  Sink<String> get addUser => _authenticationController.sink;
  /// Stream for reading the authenticated users UID/token
  Stream<String> get user => _authenticationController.stream;
  /// Stream controller for logging out a user
  final StreamController<bool> _logoutController = StreamController<bool>();
  /// Sink for addning logout events, true for logout
  Sink<bool> get addLogoutUser => _logoutController.sink;
  /// Stream for reading a logout event, true for logout
  Stream<bool> get listLogoutUser => _logoutController.stream;


  FirebaseAuthenticationBloc(this.authenticationApi) {
    onAuthChanged();
  }

  /// Checks Firebase instance for when authentication in the application have
  /// changed, if changed add UID or null to authentication stream
  /// Adds listener to logout stream
  void onAuthChanged() {
    authenticationApi.getFirebaseAuth().authStateChanges().listen((user) async {
      String uid = user != null
          ? user.jwt
          : null;

      if (user != null && (await authenticationApi.isEmailVerified())) {
        addUser.add(uid);
      } else {
        addUser.add(null);
      }

    });
    _logoutController.stream.listen((logout) {
      if (logout == true) {
        _signOut();
      }
    });
  }

  /// Logout the user.
  void _signOut() {
    authenticationApi.signOut();
  }

  /// Dispose and close streams
  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }
}