import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../core/comman/helpers/gap.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../presentation/riverpods/service_provider_riverpod.dart';
import '../../presentation/riverpods/service_provider_state.dart';

class BecomeServiceProviderScreen extends ConsumerWidget {
  const BecomeServiceProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceProviderState = ref.watch(serviceProviderRiverpodProvider);

    ref.listen(serviceProviderRiverpodProvider, (previous, next) {
      if (next.isSuccess()) {
        showSnackBar(
            context, "Service provider request submitted successfully!");
        Navigator.pop(context);
      } else if (next.isError()) {
        showSnackBar(context, next.errorMessage ?? "An error occurred");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Become a Service Provider',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: serviceProviderState.isLoading()
          ? const Center(
              child: CircularProgressIndicator(
              color: AppPallete.binkForText,
            ))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header banner with gradient
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppPallete.binkForText, Color(0xFFFF96AD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Become a Service Provider',
                          style: TextStyles.Blinker24boldBlack.copyWith(
                            color: Colors.white,
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Upload your ID to join our service provider community',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Steps indicator
                        _buildStepIndicator(
                          serviceProviderState.frontIdImage != null &&
                              serviceProviderState.backIdImage != null,
                          serviceProviderState.isImageUploaded(),
                        ),
                        SizedBox(height: 32.h),

                        // Section title with icon
                        Row(
                          children: [
                            Icon(
                              Icons.perm_identity,
                              color: AppPallete.binkForText,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'National ID Verification',
                              style: TextStyles.Blinker18semiBoldBlack.copyWith(
                                fontSize: 20.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Please upload clear photos of both sides of your national ID',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Front ID Image
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Front Side of National ID',
                              style: TextStyles.Blinker16regularlightBlack
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            _buildImagePicker(
                              context,
                              ref,
                              serviceProviderState.frontIdImage,
                              () => ref
                                  .read(
                                      serviceProviderRiverpodProvider.notifier)
                                  .pickFrontIdImage(),
                              'Upload front side',
                              Icons.credit_card_rounded,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Back ID Image
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Back Side of National ID',
                              style: TextStyles.Blinker16regularlightBlack
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            _buildImagePicker(
                              context,
                              ref,
                              serviceProviderState.backIdImage,
                              () => ref
                                  .read(
                                      serviceProviderRiverpodProvider.notifier)
                                  .pickBackIdImage(),
                              'Upload back side',
                              Icons.credit_card_outlined,
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // Privacy note
                        if (serviceProviderState.frontIdImage != null &&
                            serviceProviderState.backIdImage != null)
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Your ID will be securely stored and used only for verification purposes.',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 32.h),

                        // Submit Button
                        if (serviceProviderState.frontIdImage != null &&
                            serviceProviderState.backIdImage != null &&
                            !serviceProviderState.isImageUploaded())
                          _buildButton(
                            'Upload ID Documents',
                            Icons.upload_file,
                            serviceProviderState.isLoading()
                                ? null
                                : () => ref
                                    .read(serviceProviderRiverpodProvider
                                        .notifier)
                                    .uploadImages(),
                          ),

                        if (serviceProviderState.isImageUploaded())
                          _buildButton(
                            'Submit Application',
                            Icons.check_circle,
                            serviceProviderState.isLoading()
                                ? null
                                : () => ref
                                    .read(serviceProviderRiverpodProvider
                                        .notifier)
                                    .submitServiceProviderRequest(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStepIndicator(bool step1Complete, bool step2Complete) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          _buildStep(1, 'Upload Documents', step1Complete, true),
          _buildStepConnector(step1Complete),
          _buildStep(2, 'Verify Documents', step2Complete, step1Complete),
          _buildStepConnector(step2Complete),
          _buildStep(3, 'Become Provider', false, step2Complete),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, bool isComplete, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isComplete
                  ? AppPallete.binkForText
                  : (isActive ? Colors.white : Colors.grey.shade200),
              border: Border.all(
                color: isComplete
                    ? AppPallete.binkForText
                    : (isActive
                        ? AppPallete.binkForText
                        : Colors.grey.shade400),
                width: 2,
              ),
            ),
            child: Center(
              child: isComplete
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      number.toString(),
                      style: TextStyle(
                        color: isActive
                            ? AppPallete.binkForText
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: isActive || isComplete ? Colors.black87 : Colors.grey,
              fontWeight:
                  isActive || isComplete ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 20.w,
      height: 2.h,
      color: isActive ? AppPallete.binkForText : Colors.grey.shade300,
    );
  }

  Widget _buildImagePicker(
    BuildContext context,
    WidgetRef ref,
    dynamic image,
    VoidCallback onTap,
    String hintText,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: image != null
          ? Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Image overlay gradient for better UI
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Edit button
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit,
                              size: 14.sp, color: AppPallete.binkForText),
                          SizedBox(width: 4.w),
                          Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppPallete.binkForText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : DottedBorder(
              color: Colors.grey.shade400,
              borderType: BorderType.RRect,
              radius: Radius.circular(12.r),
              dashPattern: const [6, 3],
              strokeWidth: 1.5,
              child: Container(
                width: double.infinity,
                height: 180.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppPallete.binkForText.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 32.sp,
                        color: AppPallete.binkForText,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      hintText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Tap to select image from gallery',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.binkForText,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
