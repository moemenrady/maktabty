import '../../../../admin/data/model/item_model.dart';

enum WishlistState {
  initial,
  loading,
  success,
  error,
}

class WishlistRiverpodState {
  final WishlistState state;
  final String? errorMessage;
  final List<ItemModel> items;

  WishlistRiverpodState({
    this.state = WishlistState.initial,
    this.errorMessage,
    this.items = const [],
  });

  bool isLoading() => state == WishlistState.loading;
  bool isSuccess() => state == WishlistState.success;
  bool isError() => state == WishlistState.error;

  WishlistRiverpodState copyWith({
    WishlistState? state,
    String? errorMessage,
    List<ItemModel>? items,
  }) {
    return WishlistRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      items: items ?? this.items,
    );
  }
}
