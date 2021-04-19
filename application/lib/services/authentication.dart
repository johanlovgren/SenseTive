import 'authentication_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> currentUserUid() async {
    User user = _firebaseAuth.currentUser;
    return user.uid;
  }

  @override
  getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmailAndPassword({String email, String password}) async {
    UserCredential userCredentials =  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredentials.user.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword({String email, String password}) async {
    UserCredential userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredentials.user.uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}