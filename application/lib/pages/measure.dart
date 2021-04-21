import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensetive/widgets/halfcircle_background.dart';
import 'package:sensetive/widgets/pulsedisplay.dart';

class Measure extends StatefulWidget {
  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  int _currentTab = 0;
  bool _isMeasuring = false;
  static int timeInSec = 0;
  Timer timer;
  int _heartRate = 137;

  @override
  void initState() {
    super.initState();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  _startTimer() {
    _isMeasuring = !_isMeasuring;
    setState(() {
      if (_isMeasuring) {
        timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            timeInSec++;
          });
        });
      } else {
        timeInSec = 0;
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: HalfcircleWidget(_isMeasuring),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    color: Colors.red.withOpacity(0.5),
                    child: !_isMeasuring
                        ? Text(
                            'Connected to \n SenseTive Sensor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _printDuration(Duration(seconds: timeInSec)),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      color: Colors.indigo.shade300.withOpacity(0.7),
                      shape: CircleBorder(),
                      onPressed: () {
                        _startTimer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          !_isMeasuring ? Icons.play_arrow : Icons.stop,
                          color: Colors.white,
                          size: 60.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: !_isMeasuring
                    ? Text(
                        'Welcome Sarah! \n Let\'s start recording \n your measurements',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          ],
                        ),
                      )
                    : PulseDisplayWidget(_heartRate),
              ),
            ],
          ),
          // TODO Change this
          //child: _currentPage,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        backgroundColor: Colors.indigo,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'User page'),
        ],
        onTap: (int value) {
          setState(() {
            _currentTab = value;
          });
        },
      ),
    );
  }
}
