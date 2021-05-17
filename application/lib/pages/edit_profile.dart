import 'package:flutter/material.dart';
import 'package:sensetive/blocs/authentication_bloc.dart';
import 'package:sensetive/blocs/authentication_bloc_provider.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/services/backend.dart';
import 'package:sensetive/services/database.dart';
import 'package:sensetive/utils/jwt_decoder.dart';

const List<String> _editOptions = [
  'Add profile picture',
  'Delete account'
];

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AuthenticationBloc _authenticationBloc;
  BackendService _backendService;


  @override
  void initState() {
    super.initState();
    _backendService = BackendService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _editOptions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_editOptions[index]),
              trailing: Icon(Icons.chevron_right),
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
      case 0:
        break;
      case 1:
        _deleteAccount();
        break;
      default:
        break;
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
                    child: Text('Back'),
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

