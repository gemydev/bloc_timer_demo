import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_demo/bloc/timer_events.dart';
import 'package:bloc_demo/bloc/timer_state.dart';
import 'package:flutter/cupertino.dart';
import '../ticker.dart';

class TimerBloc extends Bloc<TimerEvents, TimerState> {
  static final int _duration = 120;
  final Ticker _ticker;
  StreamSubscription<int> _tickerSubscription;
  TimerBloc({@required Ticker ticker}) : _ticker = ticker, super(Ready(_duration));

  @override
  TimerState get initialState => Ready(_duration);

  @override
  Stream<TimerState> mapEventToState(TimerEvents event) async* {
    if (event is Start) {
      Start start = event;
      yield Running(start.duration);
      _tickerSubscription?.cancel();
      _tickerSubscription =
          _ticker.tick(ticks: start.duration).listen((duration) {
            add(Tick(duration: duration));
          });
    } else if (event is Pause) {
      if (state is Running) {
        _tickerSubscription.pause();
        yield Paused(state.duration);
      }
    } else if (event is Resume) {
      if (state is Paused) {
        _tickerSubscription?.resume();
        yield Running(state.duration);
      }
    } else if (event is Reset) {
      _tickerSubscription?.cancel();
      yield Ready(_duration);
    } else if (event is Tick) {
      Tick tick = event;
      yield tick.duration > 0 ? Running(tick.duration) : Finished();
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}