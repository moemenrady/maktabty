import 'dart:io';

enum ServiceProviderState {
  initial,
  loading,
  success,
  error,
  imageUploaded,
}

class ServiceProviderRiverpodState {
  final ServiceProviderState state;
  final String? errorMessage;
  final File? frontIdImage;
  final File? backIdImage;
  final String? frontIdUrl;
  final String? backIdUrl;
  final bool isServiceProviderRequestCreated;

  ServiceProviderRiverpodState({
    this.state = ServiceProviderState.initial,
    this.errorMessage,
    this.frontIdImage,
    this.backIdImage,
    this.frontIdUrl,
    this.backIdUrl,
    this.isServiceProviderRequestCreated = false,
  });

  ServiceProviderRiverpodState copyWith({
    ServiceProviderState? state,
    String? errorMessage,
    File? frontIdImage,
    File? backIdImage,
    String? frontIdUrl,
    String? backIdUrl,
    bool? isServiceProviderRequestCreated,
  }) {
    return ServiceProviderRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      frontIdImage: frontIdImage ?? this.frontIdImage,
      backIdImage: backIdImage ?? this.backIdImage,
      frontIdUrl: frontIdUrl ?? this.frontIdUrl,
      backIdUrl: backIdUrl ?? this.backIdUrl,
      isServiceProviderRequestCreated: isServiceProviderRequestCreated ??
          this.isServiceProviderRequestCreated,
    );
  }

  bool isInitial() => state == ServiceProviderState.initial;
  bool isLoading() => state == ServiceProviderState.loading;
  bool isSuccess() => state == ServiceProviderState.success;
  bool isError() => state == ServiceProviderState.error;
  bool isImageUploaded() => state == ServiceProviderState.imageUploaded;
}
