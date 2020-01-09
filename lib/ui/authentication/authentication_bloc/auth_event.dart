import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AppStartedEvent extends AuthenticationEvent {}

class LoggedInEvent extends AuthenticationEvent {}

class LoggedOutEvent extends AuthenticationEvent {}
