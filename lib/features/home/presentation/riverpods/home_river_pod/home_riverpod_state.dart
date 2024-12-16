import '../../../../../core/comman/entitys/categories.dart';

enum HomeState {
  initial,
  loading,
  success,
  error,
}

extension HomeStateX on HomeRiverpodState {
  bool isInitial() => state == HomeState.initial;
  bool isLoading() => state == HomeState.loading;
  bool isSuccess() => state == HomeState.success;
  bool isError() => state == HomeState.error;
}

class HomeRiverpodState {
  final HomeState state;
  final String? errorMessage;
  final List<Categories>? categories;

  HomeRiverpodState({
    this.state = HomeState.initial,
    this.errorMessage,
    this.categories,
  });

  HomeRiverpodState copyWith({
    HomeState? state,
    String? errorMessage,
    List<Categories>? categories,
  }) {
    return HomeRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
    );
  }
}
