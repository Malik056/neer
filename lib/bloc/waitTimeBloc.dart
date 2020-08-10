import 'dart:async';

import 'package:bloc/bloc.dart';

enum StopWatchEvents { start, stop, decrement }

class WaitingTimeBloc extends Bloc<StopWatchEvents, int> {
  Timer timer;
  final int maxTime = 30;
  WaitingTimeBloc() : super(0) {
    // timer = Timer.periodic(Duration(seconds: 1), (_timer) {
    //   add(StopWatchEvents.decrement);
    // });
  }

  void dispose() {
    timer?.cancel();
  }

  @override
  Stream<int> mapEventToState(event) async* {
    print(event);
    if (event == StopWatchEvents.start) {
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 1), (_timer) {
        add(StopWatchEvents.decrement);
      });
      yield maxTime;
    } else if (event == StopWatchEvents.decrement) {
      if (state == 1) {
        timer?.cancel();
      }
      yield state - 1;
    } else if (event == StopWatchEvents.stop) {
      timer?.cancel();
      yield 0;
    }
  }
}
