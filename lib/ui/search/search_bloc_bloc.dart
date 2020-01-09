import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_chat_share/data/repositories/firestore_repository.dart';

import './bloc.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  final FireStoreRepository _storeRepository;

  SearchBloc({FireStoreRepository fireStoreRepository})
      : _storeRepository = fireStoreRepository ?? FireStoreRepository();

  @override
  SearchBlocState get initialState => InitialSearchBlocState();

  @override
  Stream<SearchBlocState> mapEventToState(SearchBlocEvent event) async* {
    if (event is SearchUserEvent) {
      QuerySnapshot querySnapshot =
          await _storeRepository.getUsersByQuery(event.query);

      if (querySnapshot != null) {
        yield SearchUserProgress();
        final List<FireStoreUser> users = querySnapshot.documents
            .map((snapshot) => FireStoreUser.fromMap(snapshot.data))
            .toList();

        yield SearchUsersState(users);
      } else {
        yield SearchUsersNotFound();
      }
    }
  }
}
