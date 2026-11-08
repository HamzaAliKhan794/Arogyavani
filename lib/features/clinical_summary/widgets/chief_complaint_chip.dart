import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class ChiefComplaintChip extends StatelessWidget {
  final String label;

  const ChiefComplaintChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Light blue fill
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFBFDBFE), // Soft blue border
          width: 1.2,
        ),
      ),
      child: Text(
        label,
        style: AppStyles.bodyMedium.copyWith(
          color: AppColors.medicalBlue,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
