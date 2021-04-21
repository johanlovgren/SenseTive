import 'package:flutter/material.dart';
import 'package:sensetive/pages/database_example.dart';
import 'history.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final List<String> _headings = ['Home', 'History', 'Profile'];
  Widget _currentPage;
  String _currentHeading;
  int _currentIndex = 0;
  List _listPages = [];



  @override
  void initState() {

    super.initState();
    // Todo Add pages in _listPages and set current page
    _listPages
      ..add(DatabaseExample()) // TODO add Home page
      ..add(History())
      ..add(Container()); // TODO add profile page
    _currentPage = _listPages[_currentIndex];
    _currentHeading = _headings[_currentIndex];
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
        // TODO Change this
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
    print('Selected index: $selectedIndex');
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[_currentIndex];
      _currentHeading = _headings[_currentIndex];
    });
  }
}

