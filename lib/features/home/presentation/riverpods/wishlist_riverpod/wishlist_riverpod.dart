import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/home_repository.dart';
import 'wishlist_state.dart';

final wishlistProvider =
    StateNotifierProvider.autoDispose<WishlistRiverpod, WishlistRiverpodState>(
  (ref) => WishlistRiverpod(
    repository: ref.watch(homeRepositoryProvider),
  )..getUserFavorites(),
);

class WishlistRiverpod extends StateNotifier<WishlistRiverpodState> {
  final HomeRepository repository;

  WishlistRiverpod({required this.repository})
      : super(WishlistRiverpodState(state: WishlistState.initial));

  Future<void> getUserFavorites() async {
    state = state.copyWith(state: WishlistState.loading);

    final result =
        await repository.getUserFavorites(1); // Using hardcoded userId for now

    result.fold(
      (failure) => state = state.copyWith(
        state: WishlistState.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        state: WishlistState.success,
        items: items,
      ),
    );
  }

  Future<void> addItemToCart(String itemId, int userId) async {
    state = state.copyWith(state: WishlistState.loading);
    final result = await repository.addItemToCart(itemId, userId);
    result.fold(
      (failure) => state = state.copyWith(
          state: WishlistState.error, errorMessage: failure.message),
      (items) => state = state.copyWith(state: WishlistState.success),
    );
  }

  Future<void> removeFromFavorites(
    int userId,
    String itemId,
  ) async {
    state = state.copyWith(state: WishlistState.loading);
    final response = await repository.removeFromFavorites(userId, itemId);
    response.fold(
      (failure) => state = state.copyWith(
        state: WishlistState.error,
        errorMessage: failure.message,
      ),
      (_) async {
        await Future.delayed(const Duration(seconds: 1), () {
          state = state.copyWith(state: WishlistState.success);
        });
        await getUserFavorites();
      },
    );
  }
}
