import '../../../../../core/comman/entitys/categories.dart';
import '../../../../admin/data/model/item_model.dart';

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
  final List<ItemModel> recommendedItems;
  final List<ItemModel> bestSellingItems;
  final Categories? selectedCategory;
  final List<ItemModel> categoryItems;
  final bool isCategoryLoading;
  final String searchQuery;
  final List<ItemModel> filteredItems;

  HomeRiverpodState({
    this.state = HomeState.initial,
    this.errorMessage,
    this.categories,
    this.recommendedItems = const [],
    this.bestSellingItems = const [],
    this.selectedCategory,
    this.categoryItems = const [],
    this.isCategoryLoading = false,
    this.searchQuery = '',
    this.filteredItems = const [],
  });

  HomeRiverpodState copyWith({
    HomeState? state,
    String? errorMessage,
    List<Categories>? categories,
    List<ItemModel>? recommendedItems,
    List<ItemModel>? bestSellingItems,
    Categories? selectedCategory,
    List<ItemModel>? categoryItems,
    bool? isCategoryLoading,
    String? searchQuery,
    List<ItemModel>? filteredItems,
  }) {
    return HomeRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      recommendedItems: recommendedItems ?? this.recommendedItems,
      bestSellingItems: bestSellingItems ?? this.bestSellingItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categoryItems: categoryItems ?? this.categoryItems,
      isCategoryLoading: isCategoryLoading ?? this.isCategoryLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredItems: filteredItems ?? this.filteredItems,
    );
  }
}
