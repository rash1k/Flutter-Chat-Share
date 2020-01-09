import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreUser {
  final String id;
  final String userName;
  final String photoUrl;
  final String email;
  final String displayName;
  final int postCount;
  final bool isAdmin;
  final String bio;
  final String location;

  FireStoreUser({
    @required this.id,
    this.userName,
    this.displayName,
    this.photoUrl = "",
    this.email,
    this.postCount = 0,
    this.isAdmin = false,
    this.bio = "",
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'photoUrl': photoUrl,
      'email': email,
      'displayName': displayName,
      'location': location,
      'postCount': postCount,
      'isAdmin': isAdmin,
      'bio': bio,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory FireStoreUser.fromMap(Map<String, dynamic> data) {
    return FireStoreUser(
      id: data['id'],
      userName: data['userName'],
      displayName: data['displayName'],
      location: data['location'],
      email: data['email'],
      postCount: data['postCount'],
      isAdmin: data['isAdmin'],
      bio: data['bio'],
    );
  }
}
