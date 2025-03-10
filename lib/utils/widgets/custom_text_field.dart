import 'package:flutter/material.dart';
import '../utils_export.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isCaps;
  final bool isNumber;
  final int? maxLength;
 final void Function(String)? onChange;


  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isNumber = false,
    this.isCaps = true,
    this.maxLength = 20,
    this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
       onChanged:onChange,
      //   (value) {
      //   if (onChange != null) {
      //     onChange?.call(); // Properly calling the callback
      //   }
      // },
      textCapitalization:
          isCaps ? TextCapitalization.characters : TextCapitalization.none,
      keyboardType: isNumber ? TextInputType.number : null,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: white300,
        hintText: hintText,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
              color: Colors.black12, style: BorderStyle.solid, width: 2),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(style: BorderStyle.none, width: 0),
        ),
      ),
    );
  }
}
