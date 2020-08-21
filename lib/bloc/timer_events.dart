import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class TimerEvents extends Equatable{

  const TimerEvents();

  @override
  List<Object> get props => [];

}

class Start extends TimerEvents{
  final int duration ;
  const Start({@required this.duration});
  @override
  String toString() {
    return 'Start : {duration :$duration}';
  }
}
class Pause extends TimerEvents {}
class Resume extends TimerEvents {}
class Reset extends TimerEvents {}
class Tick extends TimerEvents {
  final int duration ;
  const Tick({@required this.duration});
  @override
  List<Object> get props => [duration];
  @override
  String toString() {
    return 'Tick : {duration:$duration}';
  }
}