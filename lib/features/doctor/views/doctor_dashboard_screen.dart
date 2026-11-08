import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/arogyavani_badge.dart';
import '../../../core/widgets/arogyavani_card.dart';
import '../../../core/widgets/global_state_views.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dr. Rajesh Sharma, MD', style: AppStyles.heading3.copyWith(fontSize: 16)),
            Text('General Medicine OPD', style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Doctor Profile & Settings',
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.medicalBlue),
            onPressed: () => context.push(AppRoutes.doctorProfile),
          ),
          ArogyavaniBadge.doctorPortal(),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () {
              LogoutConfirmationDialog.show(
                context,
                onConfirmLogout: () => context.go(AppRoutes.roleSelection),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ArogyavaniCard(
              padding: const EdgeInsets.all(18),
              onTap: () => context.push(AppRoutes.doctorQrScanner),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.emeraldBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.emeraldSuccess),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scan Patient QR Code', style: AppStyles.heading3.copyWith(fontSize: 15)),
                        Text('Instantly access patient clinical history', style: AppStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Live OPD Queue (Ready for Consultation)', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 12),
            ArogyavaniCard(
              onTap: () => context.push(AppRoutes.clinicalReport),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.medicalBlueSoft,
                    child: const Text('H', style: TextStyle(color: AppColors.medicalBlue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HAMZA (Token #12)', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        Text('Symptoms: Fever, General body pain (SOAP ready)', style: AppStyles.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
