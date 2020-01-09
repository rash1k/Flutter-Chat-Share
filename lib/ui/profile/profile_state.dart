import 'package:equatable/equatable.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class InitialProfileState extends ProfileState {}

class FetchProfileInfoState extends ProfileState {
  final FireStoreUser user;
  final int postCount;

  FetchProfileInfoState(this.user, this.postCount);

  @override
  List<Object> get props {
    return [user, postCount];
  }
}

class UpdateProfileInfoState extends ProfileState {}
