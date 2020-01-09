import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FireStorePost {
  final String postId;
  final String ownerId;
  final String userName;
  final String mediaUrl;
  final String location;
  final String description;
  final String timeStamp;
  final Map<String, bool> likes;
  final int likeCount;

  FireStorePost({
    @required this.postId,
    @required this.ownerId,
    @required this.userName,
    @required this.mediaUrl,
    this.location,
    @required this.description,
    this.timeStamp,
    this.likes,
    this.likeCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'ownerId': ownerId,
      'userName': userName,
      'photoUrl': mediaUrl,
      'location': location,
      'description': description,
      'timeStamp': FieldValue.serverTimestamp(),
      'likes': likes,
    };
  }

  factory FireStorePost.fromMap(Map<String, dynamic> data) {
    Map<String, bool> likes = data['likes'];

    var likesCount = likes == null
        ? 0
        : (Map.from(likes)..removeWhere((_, value) => value == false)).length;

    return FireStorePost(
      postId: data['postId'],
      ownerId: data['ownerId'],
      userName: data['userName'],
      mediaUrl: data['photoUrl'],
      location: data['location'],
      description: data['description'],
      timeStamp: data['timestamp'],
      likes: likes,
      likeCount: likesCount,
    );
  }
}
