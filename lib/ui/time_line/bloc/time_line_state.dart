import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TimeLineState extends Equatable {
  const TimeLineState();

  @override
  List<Object> get props => [];
}

class InitialTimeLineState extends TimeLineState {}

class UserExistsState extends TimeLineState {
  final bool isUserExists;

  UserExistsState({@required this.isUserExists});

  factory UserExistsState.exists() {
    return UserExistsState(isUserExists: true);
  }
}
