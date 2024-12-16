import '../../../../admin/data/model/item_model.dart';

enum ItemsState {
  initial,
  loading,
  success,
  error,
}

extension ItemsStateX on ItemsRiverpodState {
  bool isInitial() => state == ItemsState.initial;
  bool isLoading() => state == ItemsState.loading;
  bool isSuccess() => state == ItemsState.success;
  bool isError() => state == ItemsState.error;
}

class ItemsRiverpodState {
  final ItemsState state;
  final String? errorMessage;
  final List<ItemModel>? items;

  ItemsRiverpodState({
    this.state = ItemsState.initial,
    this.errorMessage,
    this.items,
  });

  ItemsRiverpodState copyWith({
    ItemsState? state,
    String? errorMessage,
    List<ItemModel>? items,
  }) {
    return ItemsRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      items: items ?? this.items,
    );
  }
}
