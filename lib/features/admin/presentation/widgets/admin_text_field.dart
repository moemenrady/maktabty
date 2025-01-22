import 'package:flutter/material.dart';

class AdminTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  const AdminTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      //TODO:Add validator Regexs
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
    );
  }
}
