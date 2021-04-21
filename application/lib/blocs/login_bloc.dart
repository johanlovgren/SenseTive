import 'dart:async';
import 'package:sensetive/classes/validators.dart';
import 'package:sensetive/services/firebase_authentication_api.dart';

class LoginBloc with Validators {
  final FirebaseAuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid = false;
  bool _passwordValid = false;

  final StreamController<String> _emailController =
  StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _passwordController =
  StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  final StreamController<bool> _enableLoginCreateButtonController =
  StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged => _enableLoginCreateButtonController.sink;
  Stream<bool> get enableLoginCreateButton => _enableLoginCreateButtonController.stream;

  final StreamController<String> _loginOrCreateButtonController =
  StreamController<String>();
  Sink<String> get loginOrCreateButtonChanged => _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton => _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController =
  StreamController<String>();
  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  final StreamController<String> _loginErrorController =
  StreamController<String>();
  Sink<String> get addLoginError => _loginErrorController.sink;
  Stream<String> get loginError => _loginErrorController.stream;

  final StreamController<String> _createAccountError =
  StreamController<String>();
  Sink<String> get addCreateAccountError => _createAccountError.sink;
  Stream<String> get createAccountError => _createAccountError.stream;

  LoginBloc(this.authenticationApi) {
    _startListenersIfEmailPasswordAreValid();
  }

  void dispose() {
    _passwordController.close();
    _emailController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();

    _loginErrorController.close();
    _createAccountError.close();
  }

  void _startListenersIfEmailPasswordAreValid() {
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = '';
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    password.listen((password){
      _password = password;
      _passwordValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = '';
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    loginOrCreate.listen((action) {
      action == 'Login'
          ? _logIn()
          : action == 'Create Account'
      ? _createAccount()
      : _sendEmailVerification();
    });
  }

  void _updateEnableLoginCreateButtonStream() {
    if (_emailValid && _passwordValid) {
      enableLoginCreateButtonChanged.add(true);
    } else {
      enableLoginCreateButtonChanged.add(false);
    }
  }

  Future<String> _logIn() async {
    String _result = '';
    if (_emailValid && _passwordValid) {
      await authenticationApi
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) async {
        _result = 'Success';
        await authenticationApi.isEmailVerified().then((verified) {
          if (!verified) {
            throw(Exception("Email not verified"));
          }
          print(verified);
        });
      }).catchError((error) {
        print('Login error: $error');
        authenticationApi.signOut();
        addLoginError.add(error.message);
        _result = error.toString();
      });
      return _result;
    } else {
      return 'Email and Password are not valid';
    }
  }

  Future<String> _createAccount() async {
    String _result = '';
    if (_emailValid && _passwordValid) {
      await authenticationApi
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) async {
        print('Created user: $user');
        _result = 'Created user: $user';
        await authenticationApi.sendEmailVerification();
        authenticationApi.signOut();
      }).catchError((error) {
        print('Creating user error: $error');
        addCreateAccountError.add(error.message);
      });
      return _result;
    } else {
      return 'Error creating user';
    }
  }

  Future<String> _sendEmailVerification() async {
    await authenticationApi.sendEmailVerification();
    return 'Successful';
  }
}