import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensetive/blocs/measuring_bloc.dart';
import 'package:sensetive/blocs/measuring_bloc_provider.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/blocs/timer_state.dart';
import 'package:sensetive/widgets/halfcircle_background.dart';
import 'package:sensetive/widgets/timer_widget.dart';
import 'package:sensetive/widgets/timer_actions.dart';
import 'package:sensetive/widgets/measuring_content_widget.dart';

/// The measure screen
class Measure extends StatefulWidget {
  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> with SingleTickerProviderStateMixin {
  ///Bloc for controlling the timer
  MeasuringBloc _measuringBloc;

  //Controller for the animation
  AnimationController _animationController;
  Animation _animation;
  bool _isMeasuring = true;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _measuringBloc = MeasuringBlocProvider.of(context).measuringBloc;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  height: MediaQuery.of(context).size.height * 0.35,
                  alignment: Alignment.center,
                  child: BlocProvider.value(
                    value: _measuringBloc.timerBloc,
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
            BlocProvider.value(
              value: _measuringBloc.timerBloc,
              child: Column(
                children: [
                  BlocBuilder<TimerBloc, TimerState>(
                      buildWhen: (previousState, state) =>
                          state.runtimeType != previousState.runtimeType,
                      builder: (context, state) =>
                          TimerActions(_animationController)),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: BlocBuilder<TimerBloc, TimerState>(
                        buildWhen: (previousState, state) =>
                            state.runtimeType != previousState.runtimeType,
                        builder: (context, state) =>
                            MeasuringContentWidget(_animation, _measuringBloc)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
