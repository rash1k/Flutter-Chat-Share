import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_share/data/repositories/auth_repository.dart';

import '../../authentication_bloc/validators.dart';
import 'bloc.dart';

class LoginRegisterBloc extends Bloc<LoginRegisterEvent, LoginRegisterState> {
  AuthRepository _authRepository;

  LoginRegisterBloc({AuthRepository authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  @override
  LoginRegisterState get initialState => LoginRegisterState.empty();

  @override
  Stream<LoginRegisterState> mapEventToState(LoginRegisterEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    } else if (event is SignUpWithCredentialsEvent) {
      yield* _mapSignUpWithCredentialsToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginRegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginRegisterState> _mapPasswordChangedToState(
      String password) async* {
    yield state.update(
      isEmailValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginRegisterState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield LoginRegisterState.loading();
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      yield LoginRegisterState.success();
    } on PlatformException catch (err) {
      var authError;
      switch (err.code) {
        case 'ERROR_INVALID_EMAIL':
          authError = 'Invalid Email';
          break;
        case 'ERROR_WRONG_PASSWORD':
          authError = 'Wrong Password';
          break;
        case 'ERROR_USER_NOT_FOUND':
          authError = 'User Not Found';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          authError = 'You made too many attempts, try again later';
          break;
        case 'c':
          authError = 'Not internet connection';
          break;
        default:
          authError = err.message;
          break;
      }
      yield LoginRegisterState.failure(authError);
    }
  }

  Stream<LoginRegisterState> _mapSignUpWithCredentialsToState(
      {String email, String password}) async* {
    yield LoginRegisterState.loading();
    try {
      await _authRepository.signUpWithEmailAndPassword(
          email: email, password: password);
      yield LoginRegisterState.success();
    } on PlatformException catch (error) {
      var authError;
      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD':
          authError = 'The password is not strong enough';
          break;
        case 'ERROR_INVALID_EMAIL':
          authError = 'The email address is malformed';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          authError = 'The email is already in use by a different account';
          break;
      }
      yield LoginRegisterState.failure(authError);
    }
  }
}
