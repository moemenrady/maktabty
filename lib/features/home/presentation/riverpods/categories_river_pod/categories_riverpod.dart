import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/home_repository.dart';
import 'categories_riverpod_state.dart';

final categoriesRiverpodProvider = StateNotifierProvider.autoDispose<
    CategoriesRiverpod, CategoriesRiverpodState>((ref) {
  final riverpod =
      CategoriesRiverpod(repository: ref.watch(homeRepositoryProvider));
  riverpod.getAllCategories();
  return riverpod;
});

class CategoriesRiverpod extends StateNotifier<CategoriesRiverpodState> {
  final HomeRepository repository;

  CategoriesRiverpod({required this.repository})
      : super(CategoriesRiverpodState(state: CategoriesState.initial));

  Future<void> getAllCategories() async {
    state = state.copyWith(state: CategoriesState.loading);
    final response = await repository.getAllCategories();
    response.fold(
      (failure) => state = state.copyWith(
        state: CategoriesState.error,
        errorMessage: failure.message,
      ),
      (categories) => state = state.copyWith(
        state: CategoriesState.success,
        categories: categories,
      ),
    );
  }
}
