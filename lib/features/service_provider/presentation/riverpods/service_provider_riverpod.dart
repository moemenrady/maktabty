import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../data/repository/service_provider_repository.dart';
import 'service_provider_state.dart';

final serviceProviderRiverpodProvider = StateNotifierProvider.autoDispose<
    ServiceProviderRiverpod, ServiceProviderRiverpodState>(
  (ref) => ServiceProviderRiverpod(
    repository: ref.watch(serviceProviderRepositoryProvider),
    ref: ref,
  ),
);

class ServiceProviderRiverpod
    extends StateNotifier<ServiceProviderRiverpodState> {
  final ServiceProviderRepository repository;
  final Ref ref;
  final ImagePicker _imagePicker = ImagePicker();

  ServiceProviderRiverpod({
    required this.repository,
    required this.ref,
  }) : super(ServiceProviderRiverpodState());

  Future<void> pickFrontIdImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      state = state.copyWith(
        frontIdImage: File(pickedImage.path),
      );
    }
  }

  Future<void> pickBackIdImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      state = state.copyWith(
        backIdImage: File(pickedImage.path),
      );
    }
  }

  Future<void> uploadImages() async {
    if (state.frontIdImage == null || state.backIdImage == null) {
      state = state.copyWith(
        state: ServiceProviderState.error,
        errorMessage: 'Both images must be provided',
      );
      return;
    }

    state = state.copyWith(state: ServiceProviderState.loading);

    // Upload front ID image
    final frontIdResult = await repository.uploadImage(
      state.frontIdImage!,
      'national_id_front',
    );

    frontIdResult.fold(
      (failure) {
        state = state.copyWith(
          state: ServiceProviderState.error,
          errorMessage: failure.message,
        );
      },
      (frontIdUrl) async {
        // Upload back ID image
        final backIdResult = await repository.uploadImage(
          state.backIdImage!,
          'national_id_back',
        );

        backIdResult.fold(
          (failure) {
            state = state.copyWith(
              state: ServiceProviderState.error,
              errorMessage: failure.message,
            );
          },
          (backIdUrl) {
            state = state.copyWith(
              state: ServiceProviderState.imageUploaded,
              frontIdUrl: frontIdUrl,
              backIdUrl: backIdUrl,
            );
          },
        );
      },
    );
  }

  Future<void> submitServiceProviderRequest() async {
    if (state.frontIdUrl == null || state.backIdUrl == null) {
      state = state.copyWith(
        state: ServiceProviderState.error,
        errorMessage: 'Images must be uploaded first',
      );
      return;
    }

    state = state.copyWith(state: ServiceProviderState.loading);

    final user = ref.read(appUserRiverpodProvider).user;
    if (user == null || user.id == null) {
      state = state.copyWith(
        state: ServiceProviderState.error,
        errorMessage: 'User not found',
      );
      return;
    }

    final userId = user.id;

    final result = await repository.createServiceProviderRequest(
      userId,
      state.frontIdUrl!,
      state.backIdUrl!,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          state: ServiceProviderState.error,
          errorMessage: failure.message,
        );
      },
      (serviceProviderRequest) async {
        final updateResult =
            await repository.updateUserToServiceProvider(userId);

        updateResult.fold(
          (failure) {
            state = state.copyWith(
              state: ServiceProviderState.error,
              errorMessage: failure.message,
            );
          },
          (success) {
            state = state.copyWith(
              state: ServiceProviderState.success,
              isServiceProviderRequestCreated: true,
            );
          },
        );
      },
    );
  }

  void resetState() {
    state = ServiceProviderRiverpodState();
  }
}
