import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';
import 'package:flutter_chat_share/data/repositories/firestore_repository.dart';

class SearchStore {
  final FireStoreRepository _storeRepository;

  SearchStore({FireStoreRepository fireStoreRepository})
      : _storeRepository = fireStoreRepository ?? FireStoreRepository();

  List<FireStoreUser> _users;
  List<FireStoreUser> get users => _users;

  Future<void> getUserByQuery(String query) async {
    QuerySnapshot querySnapshot = await _storeRepository.getUsersByQuery(query);

    if (querySnapshot != null) {
      _users = querySnapshot.documents
          .map((snapshot) => FireStoreUser.fromMap(snapshot.data))
          .toList();
    }
  }
}
