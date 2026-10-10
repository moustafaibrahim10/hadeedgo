import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'auth_text_field.dart';

class AuthFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextDirection textDirection;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? errorText;

  const AuthFormField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textDirection = TextDirection.rtl,
    this.suffixIcon,
    this.validator,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5A4136),
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        SizedBox(height: 6.h),
        AuthTextField(
          controller: controller,
          hint: hint,
          prefixIcon: prefixIcon,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textDirection: textDirection,
          suffixIcon: suffixIcon,
          validator: validator,
          errorText: errorText,
        ),
      ],
    );
  }
}
