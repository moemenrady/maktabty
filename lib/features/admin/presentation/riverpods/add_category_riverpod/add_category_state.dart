import 'dart:io';

class AddCategoryState {
  final bool isLoading;
  final String error;
  final bool isSuccess;
  final File? image;

  AddCategoryState({
    required this.isLoading,
    required this.error,
    required this.isSuccess,
    this.image,
  });

  AddCategoryState.initial()
      : isLoading = false,
        error = '',
        isSuccess = false,
        image = null;

  AddCategoryState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    File? image,
  }) {
    return AddCategoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      image: image ?? this.image,
    );
  }
}
