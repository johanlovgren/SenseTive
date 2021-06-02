import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sensetive/blocs/timer_state.dart';
import 'package:sensetive/blocs/timer_event.dart';
import 'package:sensetive/classes/ticker.dart';

/// BLoC used to controll the timer states and events
/// [_ticker] acts as the increasing time of the timer
/// [_tickerSubscription] Stream that listen to the timer ticking
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 0;
  int _currentDuration = 0;
  StreamSubscription<int> _tickerSubscription;

  /// Constructing the Timer BLoC
  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker,
        super(TimerInitial(_duration));

  /// A stream that maps the recieved event to its respectivt state
  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield* _mapTimerStartedToState(event);
    } else if (event is TimerPaused) {
      yield* _mapTimerPausedToState(event);
    } else if (event is TimerResumed) {
      yield* _mapTimerResumedToState(event);
    } else if (event is TimerReset) {
      yield* _mapTimerResetToState(event);
    } else if (event is TimerTicked) {
      yield* _mapTimerTickedToState(event);
    }
  }

  /// Closes the timer BLoC
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  /// Get the current duration of the timer
  int getCurrentDuration() {
    return _currentDuration;
  }

  ///Stream that maps an event to its state
  Stream<TimerState> _mapTimerStartedToState(TimerStarted start) async* {
    yield TimerRunInProgress(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  ///Stream that maps an event to its state
  Stream<TimerState> _mapTimerPausedToState(TimerPaused pause) async* {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      yield TimerRunPause(state.duration);
    }
  }

  ///Stream that maps an event to its state
  Stream<TimerState> _mapTimerResumedToState(TimerResumed resume) async* {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      yield TimerRunInProgress(state.duration);
    }
  }

  ///Stream that maps an event to its state
  Stream<TimerState> _mapTimerResetToState(TimerReset reset) async* {
    _tickerSubscription?.cancel();
    _currentDuration = 0;
    yield TimerInitial(_duration);
  }

  ///Stream that maps an event to its state
  Stream<TimerState> _mapTimerTickedToState(TimerTicked tick) async* {
    print(tick.duration);
    _currentDuration = tick.duration;
    yield tick.duration < 7200
        ? TimerRunInProgress(tick.duration)
        : TimerRunComplete();
  }
}
