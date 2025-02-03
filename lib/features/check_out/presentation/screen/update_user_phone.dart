import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/core/comman/app_user/app_user_state.dart';
import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';

class UpdateUserPhoneScreen extends ConsumerStatefulWidget {
  const UpdateUserPhoneScreen({super.key});

  @override
  ConsumerState<UpdateUserPhoneScreen> createState() =>
      _UpdateUserPhoneScreenState();
}

class _UpdateUserPhoneScreenState extends ConsumerState<UpdateUserPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _updatePhone() {
    if (_formKey.currentState!.validate()) {
      final phone = int.tryParse(_phoneController.text);
      if (phone != null) {
        ref.read(appUserRiverpodProvider.notifier).updateUserPhoneNumber(phone);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appUserRiverpodProvider, (previous, next) {
      if (next.isUpdateUserPhoneNumberInSupabase()) {
        ref
            .read(appUserRiverpodProvider.notifier)
            .updateUserPhoneNumberInLocalStorage(
                int.parse(_phoneController.text));
      }
      if (next.isUpdateUserPhoneNumberInLocalStorage()) {
        showSnackBar(context, 'Phone number updated successfully');
        Navigator.pop(context);
      }
      if (next.isError()) {
        showSnackBar(
            context, next.errorMessage ?? 'Error updating phone number');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Phone Number',
          style: TextStyles.Blinker18semiBoldBlack,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter your phone number to continue with checkout',
                style: TextStyles.Blinker16regularlightBlack,
              ),
              SizedBox(height: 24.h),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+20 ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: const Color(0xFFF68B3B).withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFF68B3B),
                    ),
                  ),
                ),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter your phone number';
                //   }
                //   if (value.length != 10) {
                //     return 'Phone number must be 10 digits';
                //   }
                //   return null;
                // },
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updatePhone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF68B3B),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Update Phone Number',
                    style: TextStyles.blinker14Boldwhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
