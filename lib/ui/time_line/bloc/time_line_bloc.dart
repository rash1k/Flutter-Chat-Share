import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_chat_share/data/repositories/auth_repository.dart';
import 'package:flutter_chat_share/data/repositories/firestore_repository.dart';

import 'bloc.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final FireStoreRepository _storeRepository;
  final AuthRepository _authRepository;

  TimeLineBloc(
      {FireStoreRepository fireStoreRepository, AuthRepository authRepository})
      : _storeRepository = fireStoreRepository ?? FireStoreRepository(),
        _authRepository = authRepository ?? AuthRepository();

  @override
  TimeLineState get initialState => InitialTimeLineState();

  @override
  Stream<TimeLineState> mapEventToState(TimeLineEvent event) async* {
    if (event is CheckCreateUserTimeLineEvent) {
      bool isUserExists =
          await _storeRepository.isUserExists(await _authRepository.userId);
      yield UserExistsState(isUserExists: isUserExists);
    } else if (event is SaveUserInFireStore) {
      FirebaseUser authUser = await _authRepository.fireBaseUser;

      _storeRepository.createUser(FireStoreUser(
        id: authUser.uid,
        userName: event.userName,
        displayName: authUser.displayName,
        email: authUser.email,
        photoUrl: authUser.photoUrl,
      ));
      yield UserExistsState(isUserExists: true);
    }
  }
}
