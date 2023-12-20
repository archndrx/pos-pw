import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textstyle.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final bool obscureText;
  final String? Function(String?)? validator; // New property for validator

  const MyTextField({
    Key? key,
    required this.controller,
    this.labelText,
    required this.obscureText,
    this.validator, // Added validator property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator, // Pass the validator to TextFormField
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD),
              width: 2,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyles.poppinsMedium.copyWith(
            fontSize: 16,
            color: Color(0xFF757575),
          ),
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
