import 'package:bloc/bloc.dart';
import 'package:flutter_chat_share/data/repositories/auth_repository.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository repository})
      : _authRepository = repository ?? AuthRepository();

  @override
  AuthState get initialState => UnInitializedState();

  @override
  Stream<AuthState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedEventToState();
    } else if (event is LoggedInEvent) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOutEvent) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedEventToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();

      if (isSignedIn) {
        yield AuthenticatedState();
      } else {
        yield UnAuthenticatedState();
      }
    } catch (_) {
      yield UnAuthenticatedState();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    yield AuthenticatedState();
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield UnAuthenticatedState();
    _authRepository.signOut();
  }
}
