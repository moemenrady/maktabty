import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';

import '../../../../admin/data/model/item_model.dart';
import '../../../data/repository/check_out_repository.dart';

final checkOutRiverpodProvider =
    StateNotifierProvider<CheckOutRiverpod, CheckOutState>((ref) {
  return CheckOutRiverpod(ref.read(checkOutRepositoryProvider));
});

class CheckOutRiverpod extends StateNotifier<CheckOutState> {
  final CheckOutRepository _checkOutRepository;

  CheckOutRiverpod(this._checkOutRepository)
      : super(CheckOutState(
            status: CheckOutStateStatus.initial,
            cartItems: [],
            errorMessage: ""));

  Future<void> addItemToCart(String itemId, int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.addItemToCart(itemId, userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) {
      state = state.copyWith(status: CheckOutStateStatus.success);
    });
  }

  void removeItemFromCart(String itemId, int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.removeItemFromCart(itemId, userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) {
      state = state.copyWith(status: CheckOutStateStatus.success);
    });
  }
}
