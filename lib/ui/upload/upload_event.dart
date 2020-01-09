import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();
  @override
  List<Object> get props => [];
}

class EmptyUploadFormEvent extends UploadEvent {}

class PickImageEvent extends UploadEvent {
  final bool isCameraOrGallery;

  PickImageEvent(this.isCameraOrGallery);

  @override
  List<Object> get props => [isCameraOrGallery];
}

class UploadPhotoEvent extends UploadEvent {
  final String location;
  final String description;

  UploadPhotoEvent(this.location, this.description);

  @override
  List<Object> get props {
    return [location, description];
  }
}
