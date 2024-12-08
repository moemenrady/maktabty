import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/admin/presentation/riverpods/category_riverpod/category_list_state.dart';
import '../../../../../core/comman/entitys/categories.dart';
import '../../../data/repository/admin_repository.dart';

final categoryListProvider =
    StateNotifierProvider<CategoryListController, CategoryListState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return CategoryListController(repository: repository);
});

class CategoryListController extends StateNotifier<CategoryListState> {
  final AdminRepository repository;

  CategoryListController({required this.repository})
      : super(CategoryListState.initial()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    state = state.copyWith(status: CategoryListStateStatus.loading);
    final result = await repository.getAllCategories();
    result.fold(
        (failure) => state = state.copyWith(
              status: CategoryListStateStatus.failure,
              error: failure.message,
            ), (categories) {
      state = state.copyWith(
        status: CategoryListStateStatus.success,
        categories: categories,
      );
      print(state.categories);
    });
  }

  Future<void> deleteCategory(int categoryId) async {
    final result = await repository.deleteCategory(categoryId);
    result.fold(
      (failure) => state = state.copyWith(
        status: CategoryListStateStatus.failure,
        error: failure.message,
      ),
      (_) => fetchCategories(),
    );
  }

  Future<void> updateCategory(Categories updatedCategory) async {
    final result = await repository.updateCategory(updatedCategory);
    result.fold(
      (failure) => state = state.copyWith(
        status: CategoryListStateStatus.failure,
        error: failure.message,
      ),
      (_) => fetchCategories(),
    );
  }
}
