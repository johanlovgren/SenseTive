import 'package:flutter/material.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

class Measure extends StatefulWidget {
  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  int _currentTab = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Arc(
                    arcType: ArcType.CONVEX,
                    edge: Edge.BOTTOM,
                    height: 70.0,
                    clipShadows: [ClipShadow(color: Colors.black)],
                    child: new Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('Connected to SenseTive Sensors'),
                ),
                Positioned(
                  top: 150.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      height: 90.0,
                      width: 90.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.lightBlue.withOpacity(0.7),
                      ),
                      child: Icon(Icons.play_arrow),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TODO Change this
          //child: _currentPage,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
