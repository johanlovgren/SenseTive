import 'package:flutter/material.dart';
import 'package:sensetive/blocs/authentication_bloc.dart';
import 'package:sensetive/blocs/authentication_bloc_provider.dart';
import 'package:sensetive/blocs/profile_bloc.dart';

final String blankProfile = 'lib/assets/images/blank_profile.png';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthenticationBloc _authenticationBloc;
  ProfileBloc _profileBloc;


  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
  }

  @override
  Widget build (BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileInformation(),
          _buildInformationButtons()
        ],
      ),
    );
  }

  Widget _buildProfileInformation() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          StreamBuilder(
            initialData: AssetImage(blankProfile),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          color: Colors.grey,
                          spreadRadius: 1,
                          offset: Offset(2, 3)
                      )
                    ]
                ),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: snapshot.data,
                ),
              );
            },
          ),
          Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 0),
              child: StreamBuilder(
                stream: _profileBloc.name,
                initialData: '',
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    snapshot.data,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                    ),
                  );
                },
              )
          ),
          StreamBuilder(
            stream: _profileBloc.email,
            initialData: '',
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(snapshot.data);
            },
          ),
          _profileButtonRow(),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Row _profileButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /*
        // Remove comment when implemented
        _profileTextButton(
            icon: Icon(Icons.people),
            text: Text('Friends'),
            onPressed: () {
              _openNextPage(context: context, index: 0);
            }
        ),
        _profileTextButton(
            icon: Icon(Icons.account_circle_outlined),
            text: Text('Edit profile'),
            onPressed: () {
              _openNextPage(context: context, index: 0);
            }
        ),
         */
        _profileTextButton(
            icon: Icon(Icons.logout),
            text: Text('Sign out'),
            onPressed: () {
              _authenticationBloc.addLogoutUser.add(true);
              print('Sign out');
            }
        ),
      ],
    );
  }

  TextButton _profileTextButton({Icon icon, Text text, @required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          icon,
          text
        ],
      ),
    );
  }

  Widget _buildInformationButtons() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: _buttons.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(_buttons[index]),
          trailing: Icon(Icons.chevron_right),
          onTap: () => _openNextPage(context: context, index: index),
        );
      },
    );
  }

  void _openNextPage({BuildContext context, bool fullscreenDialog = false, int index}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: fullscreenDialog,
            builder: (context) {
              Widget nextPage;
              switch (index) {
                case 0:
                  nextPage = dummy();
                  break;
                case 1:
                  nextPage = dummy();
                  break;
                case 2:
                  nextPage = dummy();
                  break;
                case 3:
                  nextPage = dummy();
                  break;
                default:
                  nextPage = dummy();
              }
              return nextPage;
            }
        )
    );
  }

  List<String> _buttons = [
    'About your pregnancy',
    'Know your contractions',
    'FAQ',
    'About us'
  ];
}

Widget dummy() {
  return Scaffold(
      appBar: AppBar(
        title: Text('Dummy'),
      ),
      body: SafeArea(
        child: Container(),
      )
  );
}