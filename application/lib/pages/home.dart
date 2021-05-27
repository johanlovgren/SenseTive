import 'package:flutter/material.dart';
import 'package:sensetive/blocs/measuring_bloc.dart';
import 'package:sensetive/blocs/measuring_bloc_provider.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/classes/ticker.dart';
import 'package:sensetive/pages/profile.dart';
import 'package:sensetive/utils/jwt_decoder.dart';
import 'history.dart';
import 'package:sensetive/blocs/home_bloc.dart';
import 'package:sensetive/blocs/home_bloc_provider.dart';
import 'package:sensetive/pages/measure.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc _homeBloc;
  MeasuringBloc _measuringBloc;

  static final List<String> _headings = ['Home', 'History', 'Profile'];
  Widget _currentPage;
  String _currentHeading;
  int _currentIndex = 0;
  List _listPages = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _measuringBloc = MeasuringBloc(
        timerBloc: TimerBloc(ticker: Ticker()),
        uid:  DecodedJwt(jwt: HomeBlocProvider.of(context).jwt).uid
    );
  }


  @override
  void dispose() {
    _homeBloc.dispose();
    _measuringBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listPages
      ..add(MeasuringBlocProvider(
        measuringBloc: _measuringBloc,
        child: Measure(),
      ))
      ..add(History())
      ..add(Profile());
    _currentPage = _listPages[_currentIndex];
    _currentHeading = _headings[_currentIndex];

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
    print('Selected index: $selectedIndex');
    setState(() {
      _currentIndex = selectedIndex;
      _currentPage = _listPages[_currentIndex];
      _currentHeading = _headings[_currentIndex];
    });
  }
}

