import 'package:flutter/material.dart';
import 'package:mktabte/core/theme/text_style.dart';

class CustomTxtBtn extends StatelessWidget {
  final String btnName;
  final VoidCallback onPress;

  const CustomTxtBtn({
    super.key,
    required this.btnName,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
                                  onPressed: onPress,
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 246, 140, 59),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 170.0, vertical: 16.0),
                                  ),
                                  child: Text(
                                    btnName,
                                    style: TextStyles.Lato16extraBoldBlack,
                                  ),
                                );
  }
}