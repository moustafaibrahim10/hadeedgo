import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppFeedback {
  const AppFeedback._();

  static void showSuccess(BuildContext context, String message) => _show(
    context,
    message,
    AppColors.primaryContainer,
    Icons.check_circle_outline,
  );

  static void showError(BuildContext context, String message) =>
      _show(context, message, AppColors.error, Icons.error_outline);

  static void showWarning(BuildContext context, String message) => _show(
    context,
    message,
    const Color(0xFFB26A00),
    Icons.warning_amber_outlined,
  );

  static void showInfo(BuildContext context, String message) =>
      _show(context, message, AppColors.secondary, Icons.info_outline);

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
