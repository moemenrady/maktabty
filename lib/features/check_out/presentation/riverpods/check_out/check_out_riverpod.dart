import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import '../../../data/repository/check_out_repository.dart';
import '../../../model/adress_model.dart';

final checkOutRiverpodProvider =
    StateNotifierProvider.autoDispose<CheckOutRiverpod, CheckOutState>((ref) {
  final checkOutRiverpod =
      CheckOutRiverpod(ref.read(checkOutRepositoryProvider));
  checkOutRiverpod.getAddress(1);
  checkOutRiverpod.getCartItems(1);

  return checkOutRiverpod;
});

class CheckOutRiverpod extends StateNotifier<CheckOutState> {
  final CheckOutRepository _checkOutRepository;

  CheckOutRiverpod(this._checkOutRepository)
      : super(CheckOutState(
            address: [],
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
      state = state.copyWith(status: CheckOutStateStatus.successAddItemToCart);
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
      state =
          state.copyWith(status: CheckOutStateStatus.successRemoveItemFromCart);
    });
  }

  void removeOneItemFromCart(String itemId, int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result =
        await _checkOutRepository.removeOneItemFromCart(itemId, userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) {
      state =
          state.copyWith(status: CheckOutStateStatus.successRemoveItemFromCart);
    });
  }

  Future<void> getCartItems(int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.getCartItems(userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) {
      state = state.copyWith(
          status: CheckOutStateStatus.success, cartItems: success);
    });
  }

  Future<void> addAddress(AddressModel address) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.addAddress(address);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) {
      print("success");
      state = state.copyWith(status: CheckOutStateStatus.success);
    });
  }

  Future<void> getAddress(int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.getAddress(userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) {
      print(success);
      state =
          state.copyWith(status: CheckOutStateStatus.success, address: success);
    });
  }
}
