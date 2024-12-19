import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustompassTxtFiels extends StatefulWidget {
  final String hinttxt;
  final TextEditingController mycontroller;

  const CustompassTxtFiels({
    super.key,
    required this.hinttxt,
    required this.mycontroller,
  });

  @override
  State<CustompassTxtFiels> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustompassTxtFiels> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: TextSelectionTheme(
        
        data: const TextSelectionThemeData(
          selectionColor: Colors.grey,
        ),
        child: TextFormField(
          controller: widget.mycontroller,
          obscureText: _obscureText,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            hintText: widget.hinttxt,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 168, 168, 168),
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 172, 172, 172),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 172, 172, 172),
              ),
            ),
            // Eye icon for toggling visibility
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
