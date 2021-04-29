import 'dart:async';

import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';

class ProfileBloc {
  DatabaseFileRoutines _databaseFileRoutines;
  UserDatabase _userDatabase;
  final String jwt;

  /// Stream for the users name
  final StreamController<String> _nameController = StreamController<String>();
  Sink<String> get _addName => _nameController.sink;
  Stream<String> get name => _nameController.stream;
  /// Stream for the users email
  final StreamController<String> _emailController = StreamController<String>();
  Sink<String> get _addEmail => _emailController.sink;
  Stream<String> get email => _emailController.stream;

  ProfileBloc({this.jwt}) {
    _databaseFileRoutines = DatabaseFileRoutines(uid: DecodedJwt(jwt: jwt).uid);
    _databaseFileRoutines.readUserData().then((json) {
      _userDatabase = userDatabaseFromJson(json);
      _addName.add(_userDatabase.name);
      _addEmail.add(_userDatabase.email);
    });
  }
  void dispose() {
    _nameController.close();
    _emailController.close();
  }
}