import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/auth/presentation/riverpod/auth_state.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../riverpod/auth_riverpod.dart';
import '../riverpod/auth_view_model.dart';

class OTPVerificationPage extends ConsumerWidget {
  final String phone;

  const OTPVerificationPage({super.key, required this.phone});

  void verifyOTP(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(authViewModelProvider);
    if (viewModel.formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).verifyOTP(
            phone: phone,
            otp: viewModel.otpController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authControllerProvider,
      (previous, next) {
        if (next.error != null) {
          showSnackBar(context, next.error!);
        } else if (next.isSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
    );

    final viewModel = ref.watch(authViewModelProvider);
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              Text('Enter the code sent to $phone'),
              const SizedBox(height: 24),
              TextFormField(
                controller: viewModel.otpController,
                decoration: const InputDecoration(labelText: 'OTP Code'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (state.isLoading())
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () => verifyOTP(context, ref),
                  child: const Text('Verify'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
