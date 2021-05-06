import 'package:flutter/material.dart';
import 'package:sensetive/blocs/timer_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensetive/blocs/timer_bloc.dart';
import 'package:sensetive/blocs/timer_state.dart';

class TimerWidget extends StatelessWidget {
  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
      return Text(
        _printDuration(Duration(seconds: state.duration)),
        textAlign: TextAlign.center,
        style: TimerWidget.timerTextStyle,
      );
    });
  }
}
