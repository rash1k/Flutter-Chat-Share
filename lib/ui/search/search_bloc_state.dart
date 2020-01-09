import 'package:equatable/equatable.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_user.dart';

abstract class SearchBlocState extends Equatable {
  @override
  List<Object> get props => [];
  const SearchBlocState();
}

class InitialSearchBlocState extends SearchBlocState {}

class SearchUsersState extends SearchBlocState {
  final List<FireStoreUser> users;

  SearchUsersState(this.users);

  @override
  List<Object> get props => [users];
}

class SearchUsersNotFound extends SearchBlocState {}

class SearchUserProgress extends SearchBlocState {}
