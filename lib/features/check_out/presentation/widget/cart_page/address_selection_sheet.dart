import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../model/adress_model.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import 'edit_address_sheet.dart';

class AddressSelectionSheet extends ConsumerWidget {
  final List<AddressModel> addresses;
  final Function(AddressModel) onAddressSelected;

  const AddressSelectionSheet({
    super.key,
    required this.addresses,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Delivery Address',
                style: TextStyles.Blinker18semiBoldBlack,
              ),
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFFF68B3B),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (addresses.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Center(
                child: Text(
                  'No addresses found. Add one!',
                  style: TextStyles.Blinker14regular,
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: addresses.length,
                separatorBuilder: (_, __) => Divider(height: 16.h),
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return InkWell(
                    onTap: () {
                      onAddressSelected(address);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF68B3B).withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFFF68B3B),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.address,
                                  style: TextStyles.Blinker16semiBoldBlack,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${address.address}, ${address.region}',
                                  style: TextStyles.Blinker14regular,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Show edit address dialog
                              showEditAddressBottomSheet(
                                context,
                                ref.read(checkOutRiverpodProvider.notifier),
                                address,
                              );
                            },
                            icon: const Icon(Icons.edit_outlined),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
