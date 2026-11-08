import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';

class QuickAccessGrid extends StatelessWidget {
  final VoidCallback onOpdVisitsTap;
  final VoidCallback onLabReportsTap;
  final VoidCallback onRxRecordsTap;
  final VoidCallback onDoctorQrTap;

  const QuickAccessGrid({
    super.key,
    required this.onOpdVisitsTap,
    required this.onLabReportsTap,
    required this.onRxRecordsTap,
    required this.onDoctorQrTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.quickAccess,
          style: AppStyles.badgeText.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickAccessTile(
                title: AppStrings.opdVisits,
                icon: Icons.assignment_outlined,
                iconBg: AppColors.tilePeachBg,
                iconColor: AppColors.tilePeachIcon,
                onTap: onOpdVisitsTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessTile(
                title: AppStrings.labReports,
                icon: Icons.description_outlined,
                iconBg: AppColors.tileMintBg,
                iconColor: AppColors.tileMintIcon,
                onTap: onLabReportsTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessTile(
                title: AppStrings.rxRecords,
                icon: Icons.medication_outlined,
                iconBg: AppColors.tileYellowBg,
                iconColor: AppColors.tileYellowIcon,
                onTap: onRxRecordsTap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickAccessTile(
                title: AppStrings.doctorQr,
                icon: Icons.badge_outlined,
                iconBg: AppColors.tileLavenderBg,
                iconColor: AppColors.tileLavenderIcon,
                onTap: onDoctorQrTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
          boxShadow: AppStyles.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
