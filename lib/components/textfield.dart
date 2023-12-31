import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textstyle.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final bool obscureText;
  final String? Function(String?)? validator;

  const MyTextField({
    Key? key,
    required this.controller,
    this.labelText,
    required this.obscureText,
    this.validator,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isPasswordVisible ? false : widget.obscureText,
        validator: widget.validator,
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
          labelText: widget.labelText,
          labelStyle: TextStyles.poppinsMedium.copyWith(
            fontSize: 16,
            color: Color(0xFF757575),
          ),
          fillColor: Colors.white,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Color(0xFF757575),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
