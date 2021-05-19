import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sensetive/blocs/authentication_bloc.dart';
import 'package:sensetive/blocs/authentication_bloc_provider.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/services/backend.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';


class Pages {
  static const List<String> pages = [
    'Add profile picture',
    'Delete account'
  ];
  static const List<Icon> icons = [
    Icon(Icons.camera_alt_outlined),
    Icon(Icons.delete_forever_outlined)
  ];
  static const profile_picture = 0;
  static const delete_account = 1;
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AuthenticationBloc _authenticationBloc;
  BackendService _backendService;
  DatabaseFileRoutines _databaseFileRoutines;


  @override
  void initState() {
    super.initState();
    _backendService = BackendService();
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
    _databaseFileRoutines = DatabaseFileRoutines(
        uid: DecodedJwt(jwt: HomeBlocProvider.of(context).jwt).uid
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: Pages.pages.length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: Pages.icons[index],
              title: Text(Pages.pages[index]),
              onTap: () => _openNextPage(context: context, index: index),
            );
          },
        ),
      ),
    );
  }

  void _openNextPage({BuildContext context, int index}) {
    // TODO Fix delete account and change profile picture
    switch (index) {
      case Pages.profile_picture:
        _selectProfilePicture();
        break;
      case Pages.delete_account:
        _deleteAccount();
        break;
      default:
        break;
    }
  }

  Future _selectProfilePicture() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    File _image;
    if (pickedFile!= null) {
      _image = File(pickedFile.path);
      print(_image);
      _databaseFileRoutines.writeProfileImage(_image);
      Navigator.of(context).pop();
    } else {
      print('No image selected');
    }
  }

  void _deleteAccount() async {
    bool deleteAccount = await _showDeleteDialog();
    if (!deleteAccount) {
      return;
    }
    try {
      // TODO make sure backend removes firebase account
      await _backendService.deleteAccount();
      String uid = DecodedJwt(jwt: HomeBlocProvider.of(context).jwt).uid;
      DatabaseFileRoutines databaseFileRoutines = DatabaseFileRoutines(uid: uid);
      await databaseFileRoutines.deleteAllData();
      _authenticationBloc.addLogoutUser.add(true);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Error'),
                content: Text(e.message),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              )
      );
    }
  }

  Future<bool> _showDeleteDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Account'),
            content: Text('Are you sure you want to delete your account?\n'
                'All your data will be lost.'),
            actions: [
              ElevatedButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          );
        }
    );
  }

}

