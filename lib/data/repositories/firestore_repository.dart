import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_post.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';

class FireStoreRepository {
  static final FireStoreRepository _instance = FireStoreRepository._internal();

  FireStoreRepository._internal();

  factory FireStoreRepository() {
    return _instance;
  }

  static final Firestore _fireStore = Firestore.instance;
  final _usersRef = _fireStore.collection('users');
  final _postsRef = _fireStore.collection('posts');

  Future<List<DocumentSnapshot>> getAllUsers() async {
    QuerySnapshot snapshot =
        await _usersRef.where('postsCount', isGreaterThan: 2).getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;

    snapshot.documents.map((doc) => doc).toList();
    return documents;
  }

  Future<DocumentSnapshot> getUserById(String userId) {
    return _usersRef.document(userId).get();
  }

  void createUser(FireStoreUser user) async =>
      _usersRef.document(user.id).setData(user.toMap(), merge: true);

  Future<void> updateUser(FireStoreUser user) =>
      _usersRef.document(user.id).updateData(user.toMap());

  Future<void> updateUserData(String docId, Map<String, dynamic> data) =>
      _usersRef.document(docId).updateData(data);

  void deleteUser(FireStoreUser user) async {
    DocumentSnapshot doc = await _usersRef.document(user.id).get();

    if (doc.exists) {
      doc.reference.delete();
    }
  }

  Future<bool> isUserExists(String userId) async {
    final DocumentSnapshot doc = await _usersRef.document(userId).get();
    return doc.exists;
  }

  Future<QuerySnapshot> getUsersByQuery(String query) {
    return _usersRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .getDocuments();
  }

  Future<void> createUserPost(FireStorePost fireStorePost) {
    return _postsRef
        .document(fireStorePost.ownerId)
        .collection('userPosts')
        .document(fireStorePost.postId)
        .setData(fireStorePost.toMap());
  }

  Future<QuerySnapshot> getProfilePosts(String profileId) {
    return _postsRef
        .document(profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
  }
}
