import 'dart:async';
import 'package:sensetive/services/backend_api.dart';

import 'firebase_authentication_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Authentication service used to authenticate users with Firebase
/// Singleton
class FirebaseAuthenticationService implements FirebaseAuthenticationApi {
  static final FirebaseAuthenticationService _firebaseAuthenticationService = FirebaseAuthenticationService._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Stream for login a user
  final StreamController<LoginEvent> _loginController = StreamController<LoginEvent>.broadcast();
  Sink<LoginEvent> get addLoginUser => _loginController.sink;
  Stream<LoginEvent> get loginUser => _loginController.stream;

  /// Stream for adding login errors
  final StreamController<String> _loginErrorController = StreamController<String>.broadcast();
  Sink<String> get addLoginError => _loginErrorController.sink;
  Stream<String> get loginError => _loginErrorController.stream;

  /// Singleton constructors
  FirebaseAuthenticationService._internal();
  factory FirebaseAuthenticationService() {
    return _firebaseAuthenticationService;
  }

  /// Dispose and close stream controllers
  void dispose() {
    _loginController.close();
    _loginErrorController.close();
  }

  /// Get current firebase user UID
  @override
  Future<String> currentUserUid() async {
    User user = _firebaseAuth.currentUser;
    return user.uid;
  }

  /// Get firebase auth
  @override
  getFirebaseAuth() {
    return _firebaseAuth;
  }

  /// Check whether the current users email is verified or not
  @override
  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  /// Send a email verification to the current users email
  @override
  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  /// Sign in a user with email and password
  ///
  /// [email] to sign in with
  /// [password] to sign in with
  @override
  Future<String> signInWithEmailAndPassword({String email, String password}) async {
    UserCredential userCredentials =  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredentials.user.uid;
  }

  /// Create a user with email and password
  ///
  /// [email] for new account
  /// [password] for new account
  @override
  Future<String> createUserWithEmailAndPassword({String email, String password}) async {
    UserCredential userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredentials.user.uid;
  }

  /// Sign out the current user
  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  /// Sign in the current user and add to stream for listening backend
  Future<void> signIn() async {
    String token = await _firebaseAuth.currentUser.getIdToken();
    addLoginUser.add(LoginEvent(method: 'Firebase', token: token));
  }
}