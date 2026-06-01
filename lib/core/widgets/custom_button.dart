import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = true,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryBg = AppColors.primary;
    final secondaryBg = isDark ? AppColors.cardDark : Colors.white;
    final textCol = isPrimary
        ? Colors.white
        : (isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary);

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textCol),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20, color: textCol),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textCol,
            ),
          ),
        ]
      ],
    );

    final style = ElevatedButton.styleFrom(
      backgroundColor: isPrimary ? primaryBg : secondaryBg,
      foregroundColor: isPrimary ? Colors.white.withOpacity(0.8) : AppColors.primary.withOpacity(0.1),
      elevation: isPrimary ? 2 : 0,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isPrimary
            ? BorderSide.none
            : BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
    );

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: buttonContent,
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    return button;
  }
}
