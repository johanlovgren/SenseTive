import 'package:flutter/material.dart';
import 'package:sensetive/blocs/authentication_bloc.dart';
import 'package:sensetive/blocs/authentication_bloc_provider.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/blocs/profile_bloc.dart';
import 'package:sensetive/pages/edit_profile.dart';

final String blankProfile = 'lib/assets/images/blank_profile.png';
const List<String> _buttons = [
  'About your pregnancy',
  'Know your contractions',
  'FAQ',
  'About us'
];

class Pages {
  static const pregnancy = 0;
  static const contractions = 1;
  static const faq = 2;
  static const about_us = 3;
  static const edit_profile = 4;
}

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
    _profileBloc = ProfileBloc(jwt: HomeBlocProvider.of(context).jwt);
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
            stream: _profileBloc.profilePicture,
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
                  radius: MediaQuery.of(context).size.height * 0.12,
                  backgroundImage: snapshot.data
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
         */
        _profileTextButton(
            icon: Icon(Icons.account_circle_outlined),
            text: Text('Edit profile'),
            onPressed: () {
              _openNextPage(context: context, nextPageIndex: Pages.edit_profile);
            }
        ),
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
          onTap: () => _openNextPage(context: context, nextPageIndex: index),
        );
      },
    );
  }

  void _openNextPage({BuildContext context, bool fullscreenDialog = false, int nextPageIndex}) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: fullscreenDialog,
            builder: (context) {
              Widget nextPage;
              switch (nextPageIndex) {
                case Pages.edit_profile:
                  nextPage = EditProfile();
                  break;
                case Pages.pregnancy:
                  nextPage = dummy(nextPageIndex);
                  break;
                case Pages.contractions:
                  nextPage = dummy(nextPageIndex);
                  break;
                case Pages.faq:
                  nextPage = dummy(nextPageIndex);
                  break;
                case Pages.about_us:
                  nextPage = dummy(nextPageIndex);
                  break;
                default:
                  nextPage = dummy(nextPageIndex);
              }
              return nextPage;
            }
        )
    );
    if (nextPageIndex == Pages.edit_profile) {
      imageCache.clear();
      imageCache.clearLiveImages();
      _profileBloc.readProfileImage();
    }
  }


}

Widget dummy(int index) {
  return Scaffold(
      appBar: AppBar(
        title: Text(_buttons[index]),
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return expansionTile(index);
            }
        ),
      )
  );
}

Widget expansionTile(int nr) {
  return ExpansionTile(
    title: Text('Question $nr'),
    children: [
      Padding(
        padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
        child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
      )
    ],
  );
}