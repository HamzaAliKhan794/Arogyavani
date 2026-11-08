import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class TestOtpBanner extends StatelessWidget {
  final String otpCode;
  final VoidCallback onAutoFill;

  const TestOtpBanner({
    super.key,
    required this.otpCode,
    required this.onAutoFill,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAutoFill,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.medicalBlueSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderDashed,
            width: 1.2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 16,
                  color: Color(0xFFF59E0B),
                ),
                const SizedBox(width: 4),
                Text(
                  'DEVELOPMENT MODE TEST OTP',
                  style: AppStyles.badgeText.copyWith(
                    color: AppColors.medicalBlueDark,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              otpCode,
              style: AppStyles.heading2.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: 6,
                fontWeight: FontWeight.w800,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Click the code above to auto-fill',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
