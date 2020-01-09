import 'package:equatable/equatable.dart';

abstract class TimeLineEvent extends Equatable {
  const TimeLineEvent();
  @override
  List<Object> get props => [];
}

class CheckCreateUserTimeLineEvent extends TimeLineEvent {}

class SaveUserInFireStore extends TimeLineEvent {
  final String userName;
  SaveUserInFireStore(this.userName);
}
