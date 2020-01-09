import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class UnInitializedState extends AuthState {}

class UnAuthenticatedState extends AuthState {
  final String msgError;

  UnAuthenticatedState([this.msgError]);

  @override
  List<Object> get props => [msgError];
}

class AuthenticatedState extends AuthState {}
