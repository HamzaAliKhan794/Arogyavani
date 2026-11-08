import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

enum BadgeVariant {
  standard,
  patientPortal,
  doctorPortal,
  opdLive,
  soapReady,
  abhaReady,
}

class ArogyavaniBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final BadgeVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const ArogyavaniBadge({
    super.key,
    required this.label,
    this.icon,
    this.variant = BadgeVariant.standard,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  factory ArogyavaniBadge.patientPortal() {
    return const ArogyavaniBadge(
      label: 'PATIENT PORTAL',
      variant: BadgeVariant.patientPortal,
      backgroundColor: Color(0xFFEFF6FF),
      textColor: AppColors.medicalBlue,
      borderColor: Color(0xFFBFDBFE),
    );
  }

  factory ArogyavaniBadge.doctorPortal() {
    return const ArogyavaniBadge(
      label: 'DOCTOR PORTAL',
      variant: BadgeVariant.doctorPortal,
      backgroundColor: Color(0xFFF0FDF4),
      textColor: AppColors.emeraldSuccess,
      borderColor: AppColors.emeraldBorder,
    );
  }

  factory ArogyavaniBadge.patient() {
    return const ArogyavaniBadge(
      label: 'PATIENT',
      variant: BadgeVariant.patientPortal,
      backgroundColor: Color(0xFFEFF6FF),
      textColor: AppColors.medicalBlue,
      borderColor: Color(0xFFBFDBFE),
    );
  }

  factory ArogyavaniBadge.doctor() {
    return const ArogyavaniBadge(
      label: 'DOCTOR',
      variant: BadgeVariant.doctorPortal,
      backgroundColor: Color(0xFFF0FDF4),
      textColor: AppColors.emeraldSuccess,
      borderColor: AppColors.emeraldBorder,
    );
  }

  factory ArogyavaniBadge.opdLive() {
    return const ArogyavaniBadge(
      label: 'OPD Live',
      variant: BadgeVariant.opdLive,
      backgroundColor: Color(0xFFECFDF5),
      textColor: AppColors.emeraldSuccess,
      borderColor: AppColors.emeraldBorder,
      icon: Icons.circle,
    );
  }

  factory ArogyavaniBadge.soapReady() {
    return const ArogyavaniBadge(
      label: 'SOAP Ready',
      variant: BadgeVariant.soapReady,
      backgroundColor: Color(0xFF166534),
      textColor: AppColors.textWhite,
      borderColor: Colors.transparent,
    );
  }

  factory ArogyavaniBadge.soapAi() {
    return const ArogyavaniBadge(
      label: 'SOAP AI',
      variant: BadgeVariant.standard,
      backgroundColor: Color(0xFFEFF6FF),
      textColor: AppColors.medicalBlue,
      borderColor: Color(0xFFBFDBFE),
    );
  }

  factory ArogyavaniBadge.abhaReady() {
    return const ArogyavaniBadge(
      label: 'ABHA Ready',
      variant: BadgeVariant.abhaReady,
      backgroundColor: Color(0xFFF0F9FF),
      textColor: Color(0xFF0369A1),
      borderColor: Color(0xFFBAE6FD),
      icon: Icons.badge_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color bg = backgroundColor ?? AppColors.secondarySurface;
    Color fg = textColor ?? AppColors.textSecondary;
    Color border = borderColor ?? AppColors.borderSubtle;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppStyles.radiusPill),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: variant == BadgeVariant.opdLive ? 8 : 12,
              color: fg,
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: AppStyles.badgeText.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
