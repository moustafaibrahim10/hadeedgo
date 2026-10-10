import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextDirection textDirection;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? errorText;

  const AuthTextField({
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
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textDirection: textDirection,
      validator: validator,
      style: TextStyle(
        fontSize: 15.sp,
        color: const Color(0xFF161C22),
        fontFamily: 'Tajawal',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFFADB5BD),
          fontSize: 15.sp,
          fontFamily: 'Tajawal',
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF565E74),
          size: 20.sp,
        ),
        suffixIcon: suffixIcon,
        errorText: errorText,
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.primaryContainer, width: 2.w),
        errorBorder: _border(color: AppColors.error, width: 1.w),
        focusedErrorBorder: _border(color: AppColors.error, width: 2.w),
      ),
    );
  }

  OutlineInputBorder _border({Color? color, double width = 0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: width == 0
          ? BorderSide.none
          : BorderSide(color: color!, width: width),
    );
  }
}
