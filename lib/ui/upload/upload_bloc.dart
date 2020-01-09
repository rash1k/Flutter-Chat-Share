import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_share/data/remotes/models/fire_store_post.dart';
import 'package:flutter_chat_share/data/repositories/auth_repository.dart';
import 'package:flutter_chat_share/data/repositories/firestore_repository.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import './bloc.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final AuthRepository _authRepository = AuthRepository();
  final FireStoreRepository _fireStoreRepository = FireStoreRepository();

  @override
  UploadState get initialState => UploadState();

  @override
  Stream<UploadState> mapEventToState(UploadEvent event) async* {
    if (event is EmptyUploadFormEvent) {
      String userPhotoUrl = (await _authRepository.fireBaseUser).photoUrl;
      yield state.empty(userPhotoUrl);
    } else if (event is PickImageEvent) {
      yield* _mapPickImageEventToState(event);
    } else if (event is UploadPhotoEvent) {
      yield* _mapUploadImageEventToState(event);
    }
  }

  Stream<UploadState> _mapPickImageEventToState(PickImageEvent event) async* {
    try {
      File pickImageFile = await _pickImageCameraOrGallery(
          chooseIsCamera: event.isCameraOrGallery);
      yield state.getPickImageFile(pickImageFile);
    } on PlatformException catch (e) {
      yield state.failurePickImage(e.message);
    }
  }

  Future<File> _pickImageCameraOrGallery(
      {@required bool chooseIsCamera}) async {
    ImageSource source =
        chooseIsCamera ? ImageSource.camera : ImageSource.gallery;
    //fixme:temporary solution added in manifest file android:requestLegacyExternalStorage="true"
    return await ImagePicker.pickImage(source: source);
  }

  Stream<UploadState> _mapUploadImageEventToState(
      UploadPhotoEvent event) async* {
    yield state.uploading();

    final uuid = Uuid().v4();
    File compressImageFile =
        await _compressImageFile(state.pickImageFile, uuid);

    yield* _uploadImageInFireStore(
      compressImageFile,
      uuid,
      event.location,
      event.description,
    );
  }

  Future<File> _compressImageFile(File pickImageFile, String uuid) async {
    Directory tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    im.Image imageFile = im.decodeImage(pickImageFile.readAsBytesSync());
    final compressImageFile = File('$path/img_$uuid')
      ..writeAsBytesSync(im.encodeJpg(imageFile, quality: 85));

    return compressImageFile;
  }

  Stream<UploadState> _uploadImageInFireStore(
    File compressImageFile,
    String postId,
    String location,
    String description,
  ) async* {
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child('images/post_$postId.jpg');

    StorageUploadTask uploadTask = storageRef.putFile(compressImageFile);

    //Update LinearProgressIndicator
    await for (StorageTaskEvent event in uploadTask.events) {
      int bytesTransferred = event.snapshot.bytesTransferred;
      int totalByteCount = event.snapshot.totalByteCount;
      double progress = 100.0 * (bytesTransferred / totalByteCount);
      yield state.setProgressUpload(progress);
      if (progress == 100) break;
    }

    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String imageUrl = await storageSnap.ref.getDownloadURL();
    FirebaseUser user = await _authRepository.fireBaseUser;

    FireStorePost fireStorePost = FireStorePost(
      postId: postId,
      ownerId: user.uid,
      userName: user.displayName,
      mediaUrl: imageUrl,
      location: "empty",
      description: description,
      likes: {},
    );
    await savePostInFireStore(fireStorePost);

    yield state.successUpload();
  }

  Future<void> savePostInFireStore(FireStorePost fireStorePost) {
    return _fireStoreRepository.createUserPost(fireStorePost);
  }
}
