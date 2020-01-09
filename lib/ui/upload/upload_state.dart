import 'dart:io';

class UploadState {
  final File pickImageFile;
  final bool isSubmitUpload;
  final bool isFailure;
  final bool isSuccess;
  final String fireStoreUserPhotoUrl;
  final String errorUploadFileMessage;
  final String errorPickImageMessage;
  final double progressUpload;

  UploadState({
    this.pickImageFile,
    this.isSubmitUpload = false,
    this.isFailure,
    this.isSuccess,
    this.fireStoreUserPhotoUrl,
    this.progressUpload = -1,
    this.errorUploadFileMessage,
    this.errorPickImageMessage,
  });

  UploadState empty(String fireStoreUserPhotoUrl) {
    return _copyWith(fireStoreUserPhotoUrl: fireStoreUserPhotoUrl);
  }

  UploadState getPickImageFile(File pickImageFile) {
    return _copyWith(
      pickImageFile: pickImageFile,
      isSubmitUpload: true,
    );
  }

  UploadState uploading() {
    return _copyWith(isSubmitUpload: false);
  }

  UploadState successUpload() {
    return _copyWith(
      isSubmitUpload: true,
      isSuccess: true,
    );
  }

  UploadState setProgressUpload(double progressUpload) {
    return _copyWith(progressUpload: progressUpload);
  }

  UploadState failurePickImage(String errorPickMessage) {
    return _copyWith(
      errorPickImage: errorPickMessage,
    );
  }

  UploadState failureUploadImage(String errorUploadMessage) {
    return _copyWith(
      uploadErrorMessage: errorUploadMessage,
      isSubmitUpload: true,
    );
  }

  UploadState _copyWith({
    final File pickImageFile,
    final bool isSubmitUpload,
    final bool isFailure,
    final bool isSuccess,
    final String fireStoreUserPhotoUrl,
    final String uploadErrorMessage,
    final String errorPickImage,
    final double progressUpload,
  }) {
    return UploadState(
      pickImageFile: pickImageFile ?? this.pickImageFile,
      isSubmitUpload: isSubmitUpload ?? this.isSubmitUpload,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      fireStoreUserPhotoUrl:
          fireStoreUserPhotoUrl ?? this.fireStoreUserPhotoUrl,
      errorUploadFileMessage: uploadErrorMessage ?? this.errorUploadFileMessage,
      errorPickImageMessage: errorPickImage ?? this.errorPickImageMessage,
      progressUpload: progressUpload ?? this.progressUpload,
    );
  }
}
