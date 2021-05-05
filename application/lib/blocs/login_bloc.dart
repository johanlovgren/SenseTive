import 'dart:async';
import 'package:sensetive/classes/validators.dart';
import 'package:sensetive/services/firebase_authentication_api.dart';

/// BLoC for logging in the users
///
/// [authenticationApi] Firebase authentication API used for authentications
class LoginBloc with Validators {
  final FirebaseAuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid = false;
  bool _passwordValid = false;

  String _emailCreateAccount;
  String _passwordCreateAccount;
  String _passwordRepeated;
  bool _emailCreateAccountValid = false;
  bool _passwordCreateAccountValid = false;
  bool _repeatedPasswordValid = false;
  bool _acceptPrivacy = false;

  /// Stream for email when creating an account
  final StreamController<String> _emailCreateAccountController =
  StreamController<String>.broadcast();
  Sink<String> get emailChangedCreateAccount => _emailCreateAccountController.sink;
  Stream<String> get emailCreateAccount => _emailCreateAccountController.stream.transform(validateEmail);

  /// Stream for privacy checkbox
  final StreamController<bool> _acceptPrivacyController = StreamController<bool>.broadcast();
  Sink<bool> get acceptPrivacyChanged => _acceptPrivacyController.sink;
  Stream<bool> get acceptPrivacy => _acceptPrivacyController.stream;

  /// Stream for password when creating an account
  final StreamController<String> _passwordCreateAccountController =
  StreamController<String>.broadcast();
  Sink<String> get passwordChangedCreateAccount => _passwordCreateAccountController.sink;
  Stream<String> get passwordCreateAccount => _passwordCreateAccountController.stream.transform(validatePassword);

  /// Stream for the repeated password when creating an account
  final StreamController<String> _repeatedPasswordCreateAccountController =
  StreamController<String>.broadcast();
  Sink<String> get repeatedPasswordChangedCreateAccount => _repeatedPasswordCreateAccountController.sink;
  Stream<String> get repeatedPasswordCreateAccount => _repeatedPasswordCreateAccountController.stream;

  /// Stream for create account button
  final StreamController<bool> _enableCreateButtonController =
  StreamController<bool>.broadcast();
  Sink<bool> get enableCreateButtonChanged => _enableCreateButtonController.sink;
  Stream<bool> get enableCreateButton => _enableCreateButtonController.stream;

  /// Stream for controlling the email that have been input by the user
  final StreamController<String> _emailController =
  StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  /// Stream for controlling the password that have been input by the user
  final StreamController<String> _passwordController =
  StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  /// Stream for checking when login/create button is to be enabled
  final StreamController<bool> _enableLoginButtonController =
  StreamController<bool>.broadcast();
  Sink<bool> get enableLoginButtonChanged => _enableLoginButtonController.sink;
  Stream<bool> get enableLoginButton => _enableLoginButtonController.stream;

  /// Stream for switching login and create account buttons
  final StreamController<String> _loginOrCreateButtonController =
  StreamController<String>();
  Sink<String> get loginOrCreateButtonChanged => _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton => _loginOrCreateButtonController.stream;

  /// Stream for login or create account
  final StreamController<String> _loginOrCreateController =
  StreamController<String>();
  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  /// Stream for login errors
  final StreamController<String> _loginErrorController =
  StreamController<String>();
  Sink<String> get addLoginError => _loginErrorController.sink;
  Stream<String> get loginError => _loginErrorController.stream;

  /// Stream for create account errors
  final StreamController<String> _createAccountDialogController =
  StreamController<String>();
  Sink<String> get addCreateAccountDialog => _createAccountDialogController.sink;
  Stream<String> get createAccountDialog => _createAccountDialogController.stream;

  LoginBloc(this.authenticationApi) {
    _startListenersIfEmailPasswordAreValid();
  }

  /// Dispose and close all controllers
  void dispose() {
    _passwordController.close();
    _emailController.close();
    _enableLoginButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();
    _loginErrorController.close();
    _createAccountDialogController.close();
    _emailCreateAccountController.close();
    _passwordCreateAccountController.close();
    _repeatedPasswordCreateAccountController.close();
    _enableCreateButtonController.close();
    _acceptPrivacyController.close();
  }

  /// Start listeners for controllers
  void _startListenersIfEmailPasswordAreValid() {
    acceptPrivacy.listen((value) {
      _acceptPrivacy = value;
      _updateEnableCreateAccountStream();
    });
    emailCreateAccount.listen((email) {
      _emailCreateAccount = email;
      _emailCreateAccountValid = true;
    }).onError((error) {
      _emailCreateAccount = '';
      _emailCreateAccountValid = false;
      _updateEnableCreateAccountStream();
    });
    passwordCreateAccount.listen((password) {
      _passwordCreateAccount = password;
      _passwordCreateAccountValid = true;
      if (password != _passwordRepeated) {
        _repeatedPasswordCreateAccountController.addError('Password does not match');
      }
    }).onError((error) {
      _passwordCreateAccount = '';
      _passwordCreateAccountValid = false;
      repeatedPasswordChangedCreateAccount.add('');
      _updateEnableCreateAccountStream();
    });
    repeatedPasswordCreateAccount.listen((password) {
      if (password.length > 0 && password != _passwordCreateAccount) {
        _repeatedPasswordCreateAccountController.addError('Password does not match');
        return;
      }
      _passwordRepeated = password;
      _repeatedPasswordValid = true;
      _updateEnableCreateAccountStream();
    }).onError((error) {
      _passwordRepeated = '';
      _repeatedPasswordValid = false;
      _updateEnableCreateAccountStream();
    });
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

  void _updateEnableCreateAccountStream() {
    if (_emailCreateAccountValid && _passwordCreateAccountValid
        && _repeatedPasswordValid && _acceptPrivacy) {
      enableCreateButtonChanged.add(true);
    } else {
      enableCreateButtonChanged.add(false);
    }
  }
  /// Used to update login/create button
  void _updateEnableLoginCreateButtonStream() {
    if (_emailValid && _passwordValid) {
      enableLoginButtonChanged.add(true);
    } else {
      enableLoginButtonChanged.add(false);
    }
  }

  /// Login the user and check if email is verified, if verified user is signed
  /// in, of not, an exception is thrown.
  Future<String> _logIn() async {
    String _result = '';
    if (_emailValid && _passwordValid) {
      await authenticationApi.signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) async {
        await authenticationApi.isEmailVerified().then((verified) async {
          if (!verified) {
            throw(Exception('Email not verified'));
          } else {
           await authenticationApi.signIn();
           _result = 'Success';
          }
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

  /// Creates an account for the user and sends a email for verification.
  ///
  /// On error, exception is thrown
  Future<String> _createAccount() async {
    String _result = '';
    if (_emailCreateAccountValid && _passwordCreateAccountValid && _acceptPrivacy) {
      await authenticationApi
          .createUserWithEmailAndPassword(email: _emailCreateAccount, password: _passwordCreateAccount)
          .then((user) async {
        print('Created user: $user');
        _result = 'Created user: $user';
        await authenticationApi.sendEmailVerification();
        authenticationApi.signOut();
        addCreateAccountDialog.add('Successful');
      }).catchError((error) {
        print('Creating user error: $error');
        addCreateAccountDialog.add(error.message);
      });
      return _result;
    } else {
      return 'Error creating user';
    }
  }

  /// Used to send email verification to the current signed in Firebase account
  Future<String> _sendEmailVerification() async {
    await authenticationApi.sendEmailVerification();
    return 'Successful';
  }
}