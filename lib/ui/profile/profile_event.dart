import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileInfoEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent(this.displayName, this.bio);

  final String displayName, bio;

  @override
  List<Object> get props => [displayName, bio];
}
