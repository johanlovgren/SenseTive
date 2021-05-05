import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';

class WelcomeBloc {
  final StreamController<bool> _userDataController = StreamController<bool>();
  Sink<bool> get _addUserDataExists => _userDataController.sink;
  Stream<bool> get userDataExists => _userDataController.stream;

  final StreamController<String> _jwtController = StreamController<String>();
  Sink<String> get addJwt => _jwtController.sink;
  Stream<String> get _jwt => _jwtController.stream;

  WelcomeBloc() {
    _init();
  }

  void dispose() {
    _userDataController.close();
    _jwtController.close();
  }

  void _init() {
    _jwt.listen((jwt) {
      DatabaseFileRoutines(uid: DecodedJwt(jwt: jwt).uid)
          .readUserData().then((json) {
        if (userDatabaseFromJson(json).name == '')
          _addUserDataExists.add(false);
        else
          _addUserDataExists.add(true);
      });
    });
  }
}