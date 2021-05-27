import 'package:flutter/material.dart';
import 'package:sensetive/blocs/measuring_bloc.dart';
import 'package:sensetive/blocs/measuring_bloc_provider.dart';
import 'package:sensetive/blocs/timer_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/blocs/timer_state.dart';

class TimerEvents {
  static const start = 0;
  static const stop = 1;
  static const pause = 2;
}

class TimerActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
        measuringBloc: MeasuringBlocProvider.of(context).measuringBloc
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    TimerBloc timerBloc,
    MeasuringBloc measuringBloc
  }) {
    final TimerState currentState = timerBloc.state;
    if (currentState is TimerInitial || currentState is TimerRunComplete) {
      return [
        Transform.scale(
          scale: 2.0,
          child: FloatingActionButton(
            backgroundColor: Colors.indigo.shade300,
            child: Icon(Icons.play_arrow),
            onPressed: () {
              timerBloc.add(TimerStarted(duration: currentState.duration));
              measuringBloc.addTimerEvent.add(TimerEvents.start);
            }
          ),
        ),
      ];
    }
    if (currentState is TimerRunInProgress) {
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () {
            measuringBloc.addTimerEvent.add(TimerEvents.pause);
            print("current duration: " +
                timerBloc.getCurrentDuration().toString());
            return timerBloc.add(TimerPaused());
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.stop),
          onPressed: () {
            measuringBloc.addTimerEvent.add(TimerEvents.stop);
            timerBloc.add(TimerReset());
          }
        ),
      ];
    }
    if (currentState is TimerRunPause) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () {
            timerBloc.add(TimerResumed());
            measuringBloc.addTimerEvent.add(TimerEvents.start);
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.stop),
          onPressed: () {
            measuringBloc.addTimerEvent.add(TimerEvents.stop);
            timerBloc.add(TimerReset());
          }
        ),
      ];
    }
    if (currentState is TimerRunComplete) {
      return [
        FloatingActionButton(
          child: Icon(Icons.stop),
          onPressed: () {
            measuringBloc.addTimerEvent.add(TimerEvents.stop);
            timerBloc.add(TimerReset());
          }
        ),
      ];
    }
    return [];
  }
}
