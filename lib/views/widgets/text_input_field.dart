import 'package:flutter/material.dart';
import 'package:tiktok_clone/services/constants/colors.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon prefixIcon;
  final bool isObscure;

  const TextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        labelStyle: const TextStyle(fontSize: 20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: CustomColors.borderColor),
        ),
      ),
    );
  }
}
