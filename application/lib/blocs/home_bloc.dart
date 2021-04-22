import 'package:sensetive/services/firebase_authentication_api.dart';

/// BLoC For Home
class HomeBloc {
  final FirebaseAuthenticationApi authenticationApi;

  HomeBloc(this.authenticationApi) {
    _startListeners();
  }

  void dispose() {
    // Close any stream controllers
  }

  void _startListeners() async {
    // Start listeners on controllers
  }
}