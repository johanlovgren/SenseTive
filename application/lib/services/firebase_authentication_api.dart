import 'package:sensetive/services/external_authentication_api.dart';

/// API for the Firebase authentication service
abstract class FirebaseAuthenticationApi implements ExternalAuthenticationApi {
  /// Get firbase auth
  getFirebaseAuth();
  /// Get the current Firebase users UID
  Future<String> currentUserUid();
  /// Sign out the current Firebase user
  Future<void> signOut();
  /// Sign in a user with email and password
  ///
  /// [email] to sign in with
  /// [password] to sign in with
  Future<String> signInWithEmailAndPassword({String email, String password});
  /// Create a user with email and password
  ///
  /// [email] for new account
  /// [password] for new account
  Future<String> createUserWithEmailAndPassword({String email, String password});
  /// Send a email verification to the current users email
  Future<void> sendEmailVerification();
  /// Check whether the current users email is verified or not
  Future<bool> isEmailVerified();
  /// Dispose the authentication API
  void dispose();
}