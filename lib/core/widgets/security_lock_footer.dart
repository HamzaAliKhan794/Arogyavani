import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_styles.dart';

class SecurityLockFooter extends StatelessWidget {
  final String? text;

  const SecurityLockFooter({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 14,
            color: AppColors.emeraldSuccess,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text ?? AppStrings.securityNotice,
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
