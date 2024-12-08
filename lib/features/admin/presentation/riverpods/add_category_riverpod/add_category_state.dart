class AddCategoryState {
  final bool isLoading;
  final bool isSuccess;
  final String error;

  AddCategoryState({
    required this.isLoading,
    required this.isSuccess,
    required this.error,
  });

  AddCategoryState.initial()
      : isLoading = false,
        isSuccess = false,
        error = '';

  AddCategoryState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return AddCategoryState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}
