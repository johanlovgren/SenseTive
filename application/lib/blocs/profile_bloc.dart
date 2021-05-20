import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';

class ProfileBloc {
  DatabaseFileRoutines _databaseFileRoutines;
  UserDatabase _userDatabase;
  final String jwt;

  /// Stream for users name
  final StreamController<String> _nameController = StreamController<String>();
  Sink<String> get _addName => _nameController.sink;
  Stream<String> get name => _nameController.stream;
  /// Stream for users email
  final StreamController<String> _emailController = StreamController<String>();
  Sink<String> get _addEmail => _emailController.sink;
  Stream<String> get email => _emailController.stream;
  /// Stream for profile picture
  final StreamController<ImageProvider> _profilePictureController = StreamController<ImageProvider>();
  Sink<ImageProvider> get _addProfilePicture => _profilePictureController.sink;
  Stream<ImageProvider> get profilePicture => _profilePictureController.stream;

  ProfileBloc({@required this.jwt}) {
    _databaseFileRoutines = DatabaseFileRoutines(uid: DecodedJwt(jwt: jwt).uid);
    readProfileImage();
    _databaseFileRoutines.readUserData().then((json) {
      _userDatabase = userDatabaseFromJson(json);
      _addName.add(_userDatabase.name);
      _addEmail.add(_userDatabase.email);
    });

  }

  void readProfileImage() {
    _databaseFileRoutines.profileImageFile.then((imageFile) {
      if (imageFile != null)
        _addProfilePicture.add(FileImage(imageFile));
    });
  }

  void dispose() {
    _nameController.close();
    _emailController.close();
    _profilePictureController.close();
  }
}