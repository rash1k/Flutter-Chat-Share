import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginRegisterEvent extends Equatable {
  const LoginRegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginRegisterEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginRegisterEvent {
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

class LoginWithCredentialsPressed extends LoginRegisterEvent {
  final String email;
  final String password;

  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}

class SignUpWithCredentialsEvent extends LoginRegisterEvent {
  final String email;
  final String password;

  const SignUpWithCredentialsEvent({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
