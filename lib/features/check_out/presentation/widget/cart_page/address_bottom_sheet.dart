import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/theme/text_style.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import '../../riverpods/check_out/check_out_state.dart';

class AddressBottomSheet extends ConsumerStatefulWidget {
  final void Function(String region, String address) onAddAddress;
  const AddressBottomSheet({super.key, required this.onAddAddress});

  @override
  ConsumerState<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends ConsumerState<AddressBottomSheet> {
  final List<String> cairoRegions = [
    'Nasr City',
    'Maadi',
    'Heliopolis',
    'Downtown',
    'Zamalek',
    '6th of October',
    'New Cairo',
    'Dokki',
    'Mohandessin',
    'Giza',
  ];

  String? selectedRegion;
  final addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkOutRiverpodProvider);
    return state.status == CheckOutStateStatus.loading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppPallete.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: TextStyles.blinker20SemiBoldBlack,
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppPallete.borderColor),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Region',
                        style: TextStyles.blinker14RegularDarkGrey,
                      ),
                      value: selectedRegion,
                      items: cairoRegions.map((String region) {
                        return DropdownMenuItem<String>(
                          value: region,
                          child: Text(
                            region,
                            style: TextStyles.blinker14RegularDarkGrey,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRegion = newValue;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: addressController,
                  maxLines: 3,
                  style: TextStyles.blinker14RegularDarkGrey,
                  decoration: InputDecoration(
                    hintText: 'Enter detailed address...',
                    hintStyle: TextStyles.blinker14RegularDarkGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          const BorderSide(color: AppPallete.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          const BorderSide(color: AppPallete.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          const BorderSide(color: AppPallete.primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedRegion != null &&
                          addressController.text.isNotEmpty) {
                        widget.onAddAddress(
                            selectedRegion!, addressController.text);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Confirm Address',
                      style: TextStyles.blinker16SemiBoldWhite,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
  }
}
