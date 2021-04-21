import 'dart:async';
import 'package:sensetive/services/backend_api.dart';
import 'package:sensetive/services/firebase_authentication_api.dart';

class AuthenticationBloc {
  final FirebaseAuthenticationApi authenticationApi;
  final StreamController<String> _authenticationController = StreamController<String>();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;
  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  final BackendApi backendService;

  AuthenticationBloc(this.authenticationApi, this.backendService) {
    onAuthChanged();
  }

  void onAuthChanged() {
    authenticationApi.getFirebaseAuth().authStateChanges().listen((user) async {
      String uid = user != null
          ? user.uid
          : null;
      if (user != null && (await authenticationApi.isEmailVerified())) {
        String token = await user.getIdToken();
        backendService.signIn(method: "Firebase", token: token);
      } else {
        uid = null;
      }
      addUser.add(uid);
    });
    _logoutController.stream.listen((logout) {
      if (logout == true) {
        _signOut();
      }
    });
  }

  void _signOut() {
    authenticationApi.signOut();
  }

  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }
}