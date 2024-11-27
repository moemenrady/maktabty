import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/riverpods/home_riverpod_state.dart';

import '../../data/repository/home_repository.dart';

final homeRiverpodProvider =
    StateNotifierProvider.autoDispose<HomeRiverpod, HomeRiverpodState>((ref) {
  final riverpod = HomeRiverpod(repository: ref.watch(homeRepositoryProvider));
  riverpod.getProducts();
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

  Future<void> getProducts() async {
    state = state.copyWith(state: HomeState.loading);
    await Future.delayed(const Duration(seconds: 3));
    final response = await repository.getProducts();
    state = state.copyWith(state: HomeState.success, categories: response);
  }
}
