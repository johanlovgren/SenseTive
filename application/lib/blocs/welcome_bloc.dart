import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensetive/classes/validators.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';

class WelcomeBloc with Validators{
  String _name;
  bool _nameValid = false;
  DatabaseFileRoutines _databaseFileRoutines;


  final StreamController<bool> _userDataController = StreamController<bool>.broadcast();
  Sink<bool> get _addUserDataExists => _userDataController.sink;
  Stream<bool> get userDataExists => _userDataController.stream;

  final StreamController<String> _jwtController = StreamController<String>();
  Sink<String> get addJwt => _jwtController.sink;
  Stream<String> get _jwtStream => _jwtController.stream;

  final StreamController<String> _nameController = StreamController<String>.broadcast();
  Sink<String> get addNameChanged => _nameController.sink;
  Stream<String> get name => _nameController.stream.transform(validateName);

  final StreamController<bool> _nextButtonEnabledController = StreamController<bool>.broadcast();
  Sink<bool> get enableNextButtonChanged => _nextButtonEnabledController.sink;
  Stream<bool> get enableNextButton => _nextButtonEnabledController.stream;

  final StreamController<bool> _nextButtonController = StreamController<bool>.broadcast();
  Sink<bool> get nextButtonChanged => _nextButtonController.sink;
  Stream<bool> get nextButton => _nextButtonController.stream;

  WelcomeBloc() {
    _init();
  }

  void dispose() {
    _userDataController.close();
    _jwtController.close();
    _nameController.close();
    _nextButtonEnabledController.close();
    _nextButtonController.close();
  }

  void _init() {
    _jwtStream.listen((jwt) {
      _databaseFileRoutines = DatabaseFileRoutines(uid: DecodedJwt(jwt: jwt).uid);
      _databaseFileRoutines.readUserData().then((json) {
        if (userDatabaseFromJson(json).name == '')
          _addUserDataExists.add(false);
        else
          _addUserDataExists.add(true);
      });
    });
    name.listen((name) {
      _name = name;
      _nameValid = true;
      _updateEnableNextButton();
    }).onError((error) {
      _name = '';
      _nameValid = false;
      _updateEnableNextButton();
    });
    nextButton.listen((event) {
      if (event) {
        UserDatabase userData = UserDatabase(
            name: _name,
            email: FirebaseAuth.instance.currentUser.email
        );
        _databaseFileRoutines.writeUserData(databaseToJson(userData));
        _addUserDataExists.add(true);
      } else {
        _addUserDataExists.add(null);
      }
    });
  }

  void _updateEnableNextButton() {
    enableNextButtonChanged.add(_nameValid);
  }
}