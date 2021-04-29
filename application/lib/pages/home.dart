import 'package:flutter/material.dart';
import 'package:sensetive/pages/database_example.dart';
import 'package:sensetive/pages/profile.dart';
import 'history.dart';
import 'package:sensetive/blocs/home_bloc.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc _homeBloc;

  static final List<String> _headings = ['Home', 'History', 'Profile'];
  Widget _currentPage;
  String _currentHeading;
  int _currentIndex = 2;
  List _listPages = [];


  @override
  void initState() {
    super.initState();
    _listPages
      ..add(DatabaseExample()) // TODO add Home page
      ..add(History())
      ..add(Profile()); // TODO add profile page
    _currentPage = _listPages[_currentIndex];
    _currentHeading = _headings[_currentIndex];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
  }


  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentHeading),
      ),
      body: SafeArea(
        child: _currentPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile'
          ),
        ],
        onTap: (selectedIndex) => _changePage(selectedIndex),
      ),
    );
  }

  void _changePage(int selectedIndex) {
    // TODO Fix this
    print('Selected index: $selectedIndex');
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[_currentIndex];
      _currentHeading = _headings[_currentIndex];
    });
  }
}

