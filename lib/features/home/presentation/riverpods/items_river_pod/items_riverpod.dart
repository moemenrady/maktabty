import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../../../data/repository/home_repository.dart';
import 'items_riverpod_state.dart';

final itemsRiverpodProvider = StateNotifierProvider.autoDispose
    .family<ItemsRiverpod, ItemsRiverpodState, Tuple2<int, int>>(
        (ref, functionData) {
  final riverpod = ItemsRiverpod(repository: ref.watch(homeRepositoryProvider));
  riverpod.getItemsWithFavoritesForCategory(
      functionData.item1, functionData.item2);
  return riverpod;
});

class ItemsRiverpod extends StateNotifier<ItemsRiverpodState> {
  final HomeRepository repository;

  ItemsRiverpod({required this.repository})
      : super(ItemsRiverpodState(state: ItemsState.initial));

  Future<void> getItemsWithFavoritesForCategory(
      int categoryId, int userId) async {
    state = state.copyWith(state: ItemsState.loading);
    final response =
        await repository.fetchItemsWithFavorites(userId, categoryId);
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

  Future<void> addToFavorites(int userId, String itemId, int categoryId) async {
    state = state.copyWith(state: ItemsState.loading);
    final response = await repository.addToFavorites(userId, itemId);
    response.fold(
      (failure) => state = state.copyWith(
        state: ItemsState.error,
        errorMessage: failure.message,
      ),
      (_) async {
        await Future.delayed(const Duration(seconds: 1), () {
          state = state.copyWith(state: ItemsState.addingToFavorites);
        });
        await getItemsWithFavoritesForCategory(categoryId, userId);
      },
    );
  }

  Future<void> removeFromFavorites(
      int userId, String itemId, int categoryId) async {
    state = state.copyWith(state: ItemsState.loading);
    final response = await repository.removeFromFavorites(userId, itemId);
    response.fold(
      (failure) => state = state.copyWith(
        state: ItemsState.error,
        errorMessage: failure.message,
      ),
      (_) async {
        await Future.delayed(const Duration(seconds: 1), () {
          state = state.copyWith(state: ItemsState.removingFromFavorites);
        });
        await getItemsWithFavoritesForCategory(categoryId, userId);
      },
    );
  }
}
