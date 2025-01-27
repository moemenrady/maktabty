import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/riverpods/home_river_pod/home_riverpod_state.dart';

import '../../../../../core/comman/entitys/categories.dart';
import '../../../data/repository/home_repository.dart';

final homeRiverpodProvider =
    StateNotifierProvider.autoDispose<HomeRiverpod, HomeRiverpodState>((ref) {
  final riverpod = HomeRiverpod(repository: ref.watch(homeRepositoryProvider));
  riverpod.getAllData();
  return riverpod;
});

class HomeRiverpod extends StateNotifier<HomeRiverpodState> {
  HomeRepository repository;
  HomeRiverpod({required this.repository})
      : super(HomeRiverpodState(state: HomeState.initial)) {
    getAllData();
  }

  Future<void> getAllData() async {
    state = state.copyWith(state: HomeState.loading);

    final categoriesResult = await repository.getAllCategories();
    final recommendedResult = await repository.getRecommendedItems();
    final bestSellingResult = await repository.getBestSellingItems();

    categoriesResult.fold(
        (failure) => state = state.copyWith(
              state: HomeState.error,
              errorMessage: failure.message,
            ), (categories) {
      categories.add(Categories(id: -1, name: 'Best Seller'));
      state = state.copyWith(categories: categories.reversed.toList());
    });

    recommendedResult.fold(
      (failure) => state = state.copyWith(
        state: HomeState.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(recommendedItems: items),
    );

    bestSellingResult.fold(
      (failure) => state = state.copyWith(
        state: HomeState.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        state: HomeState.success,
        bestSellingItems: items,
      ),
    );
  }

  Future<void> selectCategory(Categories category) async {
    state = state.copyWith(
      selectedCategory: category,
      isCategoryLoading: true,
    );

    if (category.id == -1) {
      // Show best selling items when "All" is selected
      state = state.copyWith(
        selectedCategory: null,
        categoryItems: state.bestSellingItems,
        isCategoryLoading: false,
      );
      return;
    }

    final result = await repository.getAllItems(category.id);
    result.fold(
      (failure) => state = state.copyWith(
        state: HomeState.error,
        errorMessage: failure.message,
        isCategoryLoading: false,
      ),
      (items) => state = state.copyWith(
        categoryItems: items,
        isCategoryLoading: false,
      ),
    );
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        filteredItems: [],
      );
      return;
    }

    final filteredItems = state.recommendedItems.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(
      searchQuery: query,
      filteredItems: filteredItems,
    );
  }
}
