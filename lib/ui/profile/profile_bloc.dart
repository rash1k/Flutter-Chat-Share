import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_chat_share/data/repositories/auth_repository.dart';
import 'package:flutter_chat_share/data/repositories/firestore_repository.dart';

import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository = AuthRepository();
  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  @override
  ProfileState get initialState => InitialProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchProfileInfoEvent) {
      DocumentSnapshot doc = await _fireStoreRepository
          .getUserById((await _authRepository.fireBaseUser).uid);

      FireStoreUser user = FireStoreUser.fromMap(doc.data);
      yield FetchProfileInfoState(user, 0);
    } else if (event is UpdateProfileEvent) {
      var currentState = state as FetchProfileInfoState;
      await _fireStoreRepository.updateUserData(
        currentState.user.id,
        <String, dynamic>{
          'displayName': event.displayName,
          'bio': event.bio,
        },
      );
      yield UpdateProfileInfoState();
    }
  }
}
