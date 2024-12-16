import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/home_repository.dart';
import 'items_riverpod_state.dart';

final itemsRiverpodProvider =
    StateNotifierProvider.autoDispose<ItemsRiverpod, ItemsRiverpodState>((ref) {
  final riverpod = ItemsRiverpod(repository: ref.watch(homeRepositoryProvider));
  riverpod.getAllItems();
  return riverpod;
});

class ItemsRiverpod extends StateNotifier<ItemsRiverpodState> {
  final HomeRepository repository;

  ItemsRiverpod({required this.repository})
      : super(ItemsRiverpodState(state: ItemsState.initial));

  Future<void> getAllItems() async {
    state = state.copyWith(state: ItemsState.loading);
    final response = await repository.getAllItems();
    response.fold(
      (failure) => state = state.copyWith(
        state: ItemsState.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        state: ItemsState.success,
        items: items,
      ),
    );
  }
}
