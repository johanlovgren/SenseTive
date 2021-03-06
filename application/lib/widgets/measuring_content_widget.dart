import 'package:flutter/material.dart';
import 'package:sensetive/blocs/measuring_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/blocs/timer_state.dart';
import 'package:sensetive/widgets/pulsedisplay.dart';

/// [animation] the animations that is displayed when measuring
/// [measuringBloc] the BLoC that controlls the measuring
class MeasuringContentWidget extends StatelessWidget {
  final Animation animation;
  final MeasuringBloc measuringBloc;

  MeasuringContentWidget(this.animation, this.measuringBloc);

  Widget build(BuildContext context) {
    return _measureContent(
        timerBloc: BlocProvider.of<TimerBloc>(context), animation: animation);
  }

  Widget _measureContent({TimerBloc timerBloc, Animation animation}) {
    final TimerState currentState = timerBloc.state;
    if (currentState is TimerInitial || currentState is TimerRunComplete) {
      return Text(
        'Welcome! \n Let\'s start recording',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.indigo,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(0.0, 0.0),
              blurRadius: 1.0,
              color: Color.fromARGB(255, 0, 0, 0),
            )
          ],
        ),
      );
    } else {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.7),
                    spreadRadius: animation.value * 1.5,
                    blurRadius: 5,
                  )
                ],
              ),
              child:
                  // TODO Fix animation
                  PulseDisplayWidget(
                      (measuringBloc.getMotherHeartRates().length == 0 || currentState is TimerRunPause)
                          ? null
                          : measuringBloc.getMotherHeartRates().last));
        },
      );
    }
  }
}
