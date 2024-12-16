import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/riverpods/home_river_pod/home_riverpod_state.dart';

import '../../../data/repository/home_repository.dart';

final homeRiverpodProvider =
    StateNotifierProvider.autoDispose<HomeRiverpod, HomeRiverpodState>((ref) {
  final riverpod = HomeRiverpod(repository: ref.watch(homeRepositoryProvider));
  riverpod.getAllCategories();
  return riverpod;
});

// final homeRemoteDataSourceProvider = Provider.family<HomeRemoteDataSource, void>(
//   (ref, _) {
//     final client = ref.watch(supabaseClientProvider);
//     return HomeRemoteDataSourceImpl(client: client);
//   },

class HomeRiverpod extends StateNotifier<HomeRiverpodState> {
  HomeRepository repository;
  HomeRiverpod({required this.repository})
      : super(HomeRiverpodState(state: HomeState.initial));

  Future<void> getAllCategories() async {
    state = state.copyWith(state: HomeState.loading);
    await Future.delayed(const Duration(seconds: 3));
    final response = await repository.getAllCategories();
    response.fold(
      (failure) => state = state.copyWith(
        state: HomeState.error,
        errorMessage: failure.message,
      ),
      (categories) => state = state.copyWith(
        state: HomeState.success,
        categories: categories,
      ),
    );
  }
}
