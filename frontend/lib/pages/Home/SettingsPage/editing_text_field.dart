import 'package:flutter/material.dart';

// EditingTextField: Reusable text field widget for settings
class EditingTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;

  const EditingTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build (BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      style: const TextStyle(
        fontSize: 13,
      ),
      cursorColor: Colors.black,
    );
  }
}