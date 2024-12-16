import '../../../../../core/comman/entitys/categories.dart';

enum CategoriesState {
  initial,
  loading,
  success,
  error,
}

extension CategoriesStateX on CategoriesRiverpodState {
  bool isInitial() => state == CategoriesState.initial;
  bool isLoading() => state == CategoriesState.loading;
  bool isSuccess() => state == CategoriesState.success;
  bool isError() => state == CategoriesState.error;
}

class CategoriesRiverpodState {
  final CategoriesState state;
  final String? errorMessage;
  final List<Categories>? categories;

  CategoriesRiverpodState({
    this.state = CategoriesState.initial,
    this.errorMessage,
    this.categories,
  });

  CategoriesRiverpodState copyWith({
    CategoriesState? state,
    String? errorMessage,
    List<Categories>? categories,
  }) {
    return CategoriesRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
    );
  }
}
