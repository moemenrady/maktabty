import 'package:flutter/material.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import 'package:mktabte/features/check_out/presentation/screen/update_user_phone.dart';
import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../model/cart_items_model.dart';
import '../riverpods/check_out/check_out_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/check_out_dialog.dart';

class CheckOutScreen extends ConsumerWidget {
  final List<CartItemsModel> cartItems;
  const CheckOutScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkOutState = ref.read(checkOutRiverpodProvider.notifier);
    final userState = ref.watch(appUserRiverpodProvider);

    ref.listen(checkOutRiverpodProvider, (previous, next) {
      if (next.isSuccessCheckOut()) {
        showCheckoutSuccessDialog(context);
      } else if (next.isError()) {
        // Show error dialog for out of stock items
        if (next.errorMessage.contains('exceed available stock') ?? false) {
          showDialog(
            context: context,
            barrierDismissible: false, // User must take action
            builder: (context) => AlertDialog(
              title: Text(
                'Insufficient Stock',
                style: TextStyles.Blinker16regularlightBlack.copyWith(
                  color: Colors.red,
                ),
              ),
              content: SingleChildScrollView(
                child: Text(
                  next.errorMessage,
                  style: TextStyles.Blinker14regular,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to cart
                  },
                  child: const Text('Return to Cart'),
                ),
              ],
            ),
          );
        } else {
          showSnackBar(
              context, next.errorMessage ?? "An unexpected error occurred");
        }
      }
    });

    void handleCheckout() {
      if (userState.user?.phone == 0) {
        // Navigate to phone update screen if phone is not set
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UpdateUserPhoneScreen(),
          ),
        );
        return;
      }

      if (checkOutState.state.selectedAddress == null) {
        showSnackBar(context, 'Please select a delivery address');
        return;
      }

      final orderItems =
          checkOutState.state.cartItems.map((item) => item.toMap()).toList();

      ref.read(checkOutRiverpodProvider.notifier).checkOut(
          ref.read(appUserRiverpodProvider).user!.id!,
          orderItems,
          checkOutState.state.selectedAddress!.id,
          "Purchase");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '\$ ${checkOutState.state.totalPrice}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Shipping',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'free',
              style: TextStyle(fontSize: 18),
            ),
            const Divider(height: 32),
            const Text(
              'Total',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '\$ ${checkOutState.state.totalPrice}',
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(height: 32),
            const Text(
              'Payment',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash'),
              trailing: const Text('Pay on delivery'),
              onTap: () {
                // Handle cash payment selection
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
