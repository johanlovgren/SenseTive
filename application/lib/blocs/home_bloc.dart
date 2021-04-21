import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensetive/services/firebase_authentication_api.dart';

class HomeBloc {
  final FirebaseAuthenticationApi authenticationApi;

  HomeBloc(this.authenticationApi) {
    _startListeners();
  }

  void dispose() {
    // Close any stream controllers
  }

  void _startListeners() async {
    User user = authenticationApi.getFirebaseAuth().currentUser;
    if (user != null) {
      await user.getIdToken().then((token) => print('Token: $token'));
    }
  }
}