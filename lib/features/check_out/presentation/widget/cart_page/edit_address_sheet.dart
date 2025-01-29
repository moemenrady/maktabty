import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../model/adress_model.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import 'address_bottom_sheet.dart';

void showEditAddressBottomSheet(
  BuildContext context,
  CheckOutRiverpod controller,
  AddressModel address,
) {
  final addressController = TextEditingController(text: address.address);
  String selectedRegion = address.region;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(checkOutRiverpodProvider);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Address',
                  style: TextStyles.Blinker18semiBoldBlack,
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
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
                ),
                SizedBox(height: 16.h),
                StatefulBuilder(
                  builder: (context, setState) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFF68B3B).withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedRegion,
                        hint: Text(
                          'Select Region',
                          style: TextStyles.Blinker14regular,
                        ),
                        items: cairoRegions.map((String region) {
                          return DropdownMenuItem<String>(
                            value: region,
                            child: Text(
                              region,
                              style: TextStyles.Blinker14regular,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedRegion = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLoading()
                        ? null
                        : () {
                            final updatedAddress = address.copyWith(
                              address: addressController.text,
                              region: selectedRegion,
                            );
                            controller.updateAddress(updatedAddress);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF68B3B),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: state.isLoading()
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Update Address',
                            style: TextStyles.blinker14Boldwhite,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
