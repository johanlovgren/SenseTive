import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/blocs/timer_state.dart';
import 'package:sensetive/classes/ticker.dart';
import 'package:sensetive/widgets/halfcircle_background.dart';
import 'package:sensetive/widgets/pulsedisplay.dart';
import 'package:sensetive/widgets/timer_widget.dart';
import 'package:sensetive/widgets/timer_actions.dart';
import 'package:sensetive/widgets/measuring_content_widget.dart';

class Measure extends StatefulWidget {
  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> with SingleTickerProviderStateMixin {
  ///Bloc for controlling the timer
  ///See [TimerBloc]
  final TimerBloc _timerBloc = TimerBloc(ticker: Ticker());

  //Controller for the animation
  AnimationController _animationController;
  Animation _animation;
  // int _currentTab = 0;
  bool _isMeasuring = true;
  // static int timeInSec = 0;
  int _heartRate = 137;
  // List<int> _momsReading = [];

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                height: MediaQuery.of(context).size.height * 0.35,
                alignment: Alignment.center,
                child: BlocProvider(
                  create: (context) => _timerBloc,
                  child: BlocBuilder<TimerBloc, TimerState>(
                    buildWhen: (previousState, state) =>
                        state.runtimeType != previousState.runtimeType,
                    builder: (context, state) => state is TimerInitial
                        ? Text(
                            'Connected to \n SenseTive Sensor',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0,
                              color: Colors.white,
                            ),
                          )
                        : TimerWidget(),
                  ),
                ),
              ),
            ],
          ),
          BlocProvider(
            create: (context) => _timerBloc,
            child: Column(
              children: [
                BlocBuilder<TimerBloc, TimerState>(
                    buildWhen: (previousState, state) =>
                        state.runtimeType != previousState.runtimeType,
                    builder: (context, state) => TimerActions()),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: BlocBuilder<TimerBloc, TimerState>(
                      buildWhen: (previousState, state) =>
                          state.runtimeType != previousState.runtimeType,
                      builder: (context, state) =>
                          MeasuringContentWidget(_animation)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}