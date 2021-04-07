import 'package:flutter/material.dart';
import 'result/result.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _currentPage;
  int _currentIndex = 0;
  List _listPages = [];


  @override
  void initState() {
    super.initState();
    // Todo Add pages in _listPages and set current page
    _listPages..add(Result());
    _currentPage = _listPages[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
              label: 'User page'
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
      //_currentIndex = selectedIndex;
      _currentPage = _listPages[_currentIndex];
    });

  }
}

