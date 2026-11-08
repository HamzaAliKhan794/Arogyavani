import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class PhysicianDisclaimerBanner extends StatelessWidget {
  const PhysicianDisclaimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7), // Warm amber background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFDE68A),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.verified_outlined,
              size: 16,
              color: AppColors.amberWarning,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Informational AI Summary · Requires Physician Review & Clinical Verification before diagnosis or treatment.',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.amberWarning,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
