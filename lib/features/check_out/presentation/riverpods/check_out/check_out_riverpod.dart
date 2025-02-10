import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../data/repository/check_out_repository.dart';
import '../../../model/adress_model.dart';

final checkOutRiverpodProvider =
    StateNotifierProvider.autoDispose<CheckOutRiverpod, CheckOutState>((ref) {
  final checkOutRiverpod =
      CheckOutRiverpod(ref.read(checkOutRepositoryProvider));
  checkOutRiverpod.getAddress(ref.read(appUserRiverpodProvider).user!.id!);
  checkOutRiverpod.getCartItems(ref.read(appUserRiverpodProvider).user!.id!);

  return checkOutRiverpod;
});

class CheckOutRiverpod extends StateNotifier<CheckOutState> {
  final CheckOutRepository _checkOutRepository;

  CheckOutRiverpod(this._checkOutRepository)
      : super(CheckOutState(
            address: [],
            status: CheckOutStateStatus.initial,
            cartItems: [],
            errorMessage: "",
            totalPrice: 0));

  Future<void> addItemToCart(String itemId, int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.addItemToCart(itemId, userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) async {
      await Future.delayed(const Duration(milliseconds: 500));
      await getCartItems(userId);
      state = state.copyWith(status: CheckOutStateStatus.successAddItemToCart);
    });
  }

  Future<void> removeItemFromCart(String itemId, int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.removeItemFromCart(itemId, userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) async {
      await Future.delayed(const Duration(milliseconds: 500));
      await getCartItems(userId);
      state =
          state.copyWith(status: CheckOutStateStatus.successRemoveItemFromCart);
    });
  }

  Future<void> removeOneItemFromCart(String itemId, int userId) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result =
        await _checkOutRepository.removeOneItemFromCart(itemId, userId);
    result.fold((failure) {
      print(failure.message);
      state = state.copyWith(
          status: CheckOutStateStatus.error, errorMessage: failure.message);
    }, (success) async {
      await Future.delayed(const Duration(milliseconds: 500));
      await getCartItems(userId);
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
      final totalPrice = success.fold(
          0.0,
          (previous, element) =>
              previous +
              (element.totalPricePerItem is int
                  ? (element.totalPricePerItem as int).toDouble()
                  : element.totalPricePerItem));
      state = state.copyWith(
          status: CheckOutStateStatus.success,
          cartItems: success,
          totalPrice: totalPrice);
    });
  }

  Future<void> addAddress(AddressModel address) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.addAddress(address);
    result.fold((failure) {
      state = state.copyWith(
        status: CheckOutStateStatus.error,
        errorMessage: failure.message,
      );
    }, (newAddress) {
      // Add the new address to the existing list
      final updatedAddresses = [...state.address, newAddress];
      state = state.copyWith(
        status: CheckOutStateStatus.successAddAddress,
        address: updatedAddresses,
      );
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

  Future<void> checkOut(
    int userId,
    List<Map<String, dynamic>> orderItems,
    int? addressId,
    String transactionType,
  ) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);

    // First check if all items are in stock
    final outOfStockItems = <String>[];

    for (var cartItem in state.cartItems) {
      // If cart quantity is greater than available stock
      if (cartItem.itemCount > cartItem.itemQuantity) {
        outOfStockItems.add(
            '${cartItem.itemName} (Requested: ${cartItem.itemQuantity}, Available: ${cartItem.itemCount})');
      }
    }

    // If any items are out of stock, return with error
    if (outOfStockItems.isNotEmpty) {
      state = state.copyWith(
        status: CheckOutStateStatus.error,
        errorMessage:
            'Some items exceed available stock:\n${outOfStockItems.join('\n')}',
      );
      return;
    }

    // Convert the order items to ensure integer prices
    final convertedOrderItems = orderItems.map((item) {
      return {
        ...item,
        'item_price': (item['item_price'] as double).toInt(),
        'total_price_per_item':
            (item['total_price_per_item'] as double).toInt(),
      };
    }).toList();

    final result = await _checkOutRepository.checkOut(
      userId,
      convertedOrderItems,
      addressId!,
      transactionType,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CheckOutStateStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) {
        state = state.copyWith(status: CheckOutStateStatus.successCheckOut);
      },
    );
  }

  void setSelectedAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  Future<void> updateAddress(AddressModel address) async {
    state = state.copyWith(status: CheckOutStateStatus.loading);
    final result = await _checkOutRepository.updateAddress(address);
    result.fold(
      (failure) {
        print(failure.message);
        state = state.copyWith(
          status: CheckOutStateStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) async {
        // Update the address in the list
        final updatedAddresses = state.address.map((a) {
          if (a.id == address.id) {
            return address;
          }
          return a;
        }).toList();

        state = state.copyWith(
          status: CheckOutStateStatus.successUpdateAddress,
          address: updatedAddresses,
          selectedAddress: address.id == state.selectedAddress?.id
              ? address
              : state.selectedAddress,
        );
      },
    );
  }
}
