import '../../../../admin/data/model/item_model.dart';

enum ItemsState {
  initial,
  loading,
  success,
  error,
  addingToFavorites,
  removingFromFavorites,
}

extension ItemsStateX on ItemsRiverpodState {
  bool isInitial() => state == ItemsState.initial;
  bool isLoading() => state == ItemsState.loading;
  bool isSuccess() => state == ItemsState.success;
  bool isError() => state == ItemsState.error;
  bool isAddingFavorite() => state == ItemsState.addingToFavorites;
  bool isRemovingFavorite() => state == ItemsState.removingFromFavorites;
}

class ItemsRiverpodState {
  final ItemsState state;
  final String? errorMessage;
  final List<ItemModel> items;
  final bool isAddingToFavorites;
  final bool isRemovingFromFavorites;

  ItemsRiverpodState({
    this.state = ItemsState.initial,
    this.errorMessage,
    this.items = const [],
    this.isAddingToFavorites = false,
    this.isRemovingFromFavorites = false,
  });

  bool isLoading() => state == ItemsState.loading;
  bool isSuccess() => state == ItemsState.success;
  bool isError() => state == ItemsState.error;
  bool isAddingFavorite() => state == ItemsState.addingToFavorites;
  bool isRemovingFavorite() => state == ItemsState.removingFromFavorites;

  ItemsRiverpodState copyWith({
    ItemsState? state,
    String? errorMessage,
    List<ItemModel>? items,
    bool? isAddingToFavorites,
    bool? isRemovingFromFavorites,
  }) {
    return ItemsRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      items: items ?? this.items,
      isAddingToFavorites: isAddingToFavorites ?? this.isAddingToFavorites,
      isRemovingFromFavorites:
          isRemovingFromFavorites ?? this.isRemovingFromFavorites,
    );
  }
}
