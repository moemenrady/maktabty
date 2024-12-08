import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/admin_repository.dart';
import 'add_category_state.dart';
import 'add_category_view_model.dart';

final addCategoryViewModelProvider =
    Provider.autoDispose<AddCategoryViewModel>((ref) {
  final viewModel = AddCategoryViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});

final addCategoryRiverpodProvider =
    StateNotifierProvider.autoDispose<AddCategoryController, AddCategoryState>(
  (ref) => AddCategoryController(
    repository: ref.watch(adminRepositoryProvider),
  ),
);

class AddCategoryController extends StateNotifier<AddCategoryState> {
  final AdminRepository _repository;

  AddCategoryController({
    required AdminRepository repository,
  })  : _repository = repository,
        super(AddCategoryState.initial());

  Future<void> addCategory(String name) async {
    state = state.copyWith(isLoading: true, error: '');
    final result = await _repository.addCategory(name);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (success) => state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      ),
    );
  }
}
