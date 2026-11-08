import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../providers/profile_provider.dart';

class DoctorAccountSettingsScreen extends ConsumerWidget {
  const DoctorAccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(profileProvider).doctorProfile;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor Account Settings', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Hospital Credentials & Clinic Configuration',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            // Medical Council Registration Card
            Text('Medical Council Registration', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
                        child: const Icon(Icons.verified_outlined, color: AppColors.medicalBlue, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.registrationNumber, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            const Text('National Medical Commission (NMC) Verified', style: TextStyle(fontSize: 11.5, color: AppColors.emeraldSuccess, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Digital Signature Token:', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      const Text('Class 3 DSC Connected', style: TextStyle(color: AppColors.medicalBlue, fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Hospital Affiliation & Room
            Text('Current OPD Clinic Affiliation', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.hospitalName, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Assigned Desk: ${d.consultationRoom}', style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text('Shift Hours: ${d.opdTiming}', style: AppStyles.bodySmall.copyWith(color: AppColors.medicalBlue, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Room assignment request sent to Hospital Administration.')),
                      );
                    },
                    icon: const Icon(Icons.edit_location_alt_outlined, size: 16),
                    label: const Text('Request Desk Change'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.medicalBlue,
                      side: const BorderSide(color: AppColors.borderSubtle),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Prescription Pad Header Configuration
            Text('Prescription Letterhead Branding', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Official Doctor Header Preview:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.fullName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.medicalBlue)),
                        Text('${d.qualifications} · Reg: ${d.registrationNumber}', style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                        Text('${d.hospitalName} · Contact: ${d.mobileNumber}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
