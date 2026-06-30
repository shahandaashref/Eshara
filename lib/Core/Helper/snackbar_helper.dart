import 'package:flutter/material.dart';
import 'package:eshara/Core/Helper/theme.dart';

class SnackbarHelper {
  /// دالة مساعدة لعرض SnackBar بتصميم متناسق وجذاب في جميع أنحاء التطبيق
  static void showCustomSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(
      context,
    ).clearSnackBars(); // إخفاء أي رسالة سابقة أولاً
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.info_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: isError ? EsharaTheme.error : EsharaTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        elevation: 4,
      ),
    );
  }
}
