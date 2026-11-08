import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/global_state_views.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class DoctorProfileScreen extends ConsumerWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final d = state.doctorProfile;

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
            Text('Doctor Clinical Profile', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Reg: ${d.registrationNumber} · Verified',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Doctor Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                  boxShadow: AppStyles.cardShadow,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFDBEAFE), width: 1.5),
                          ),
                          child: const Center(
                            child: Icon(Icons.medical_information_outlined, color: AppColors.medicalBlue, size: 32),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      d.fullName,
                                      style: AppStyles.heading2.copyWith(fontSize: 17),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                    decoration: BoxDecoration(
                                      color: AppColors.emeraldBg,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'Verified MD',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.emeraldSuccess),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                d.specialty,
                                style: AppStyles.bodySmall.copyWith(color: AppColors.medicalBlue, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                d.hospitalName,
                                style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: 14),

                    // Metrics Row
                    Row(
                      children: [
                        _DoctorStat(label: 'Experience', value: '${d.yearsOfExperience} Yrs'),
                        _DoctorStat(label: 'OPD Room', value: d.consultationRoom.split(',').first),
                        _DoctorStat(label: 'MCI Reg', value: 'Active'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Qualifications & Timings Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                  boxShadow: AppStyles.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Credentials & Hospital Schedule', style: AppStyles.heading3.copyWith(fontSize: 14.5)),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.school_outlined, size: 18, color: AppColors.medicalBlue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            d.qualifications,
                            style: AppStyles.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.schedule_rounded, size: 18, color: AppColors.medicalBlue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'OPD Duty: ${d.opdTiming}',
                            style: AppStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.verified_rounded, size: 18, color: AppColors.emeraldSuccess),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Digital Prescription Certificate: Active (MCI / NBE Approved)',
                            style: AppStyles.bodySmall.copyWith(color: AppColors.emeraldSuccess, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Doctor Settings Actions
              Text('Consultation Terminal Settings', style: AppStyles.heading3.copyWith(fontSize: 15)),
              const SizedBox(height: 10),

              _DoctorMenuTile(
                icon: Icons.tune_rounded,
                title: 'Consultation Preferences',
                subtitle: 'Slot pacing (15 min), auto-queue advance & SOAP view',
                onTap: () => context.push(AppRoutes.doctorConsultationPreferences),
              ),
              const SizedBox(height: 8),

              _DoctorMenuTile(
                icon: Icons.notifications_none_rounded,
                title: 'Clinical Notification Settings',
                subtitle: 'New token in queue, emergency arrivals & critical lab alerts',
                onTap: () => context.push(AppRoutes.doctorNotifications),
              ),
              const SizedBox(height: 8),

              _DoctorMenuTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Doctor Account & Hospital Affiliation',
                subtitle: 'Registration certificate, clinic branding & letterhead',
                onTap: () => context.push(AppRoutes.doctorSettings),
              ),
              const SizedBox(height: 8),

              _DoctorMenuTile(
                icon: Icons.help_outline_rounded,
                title: 'Doctor Clinical Guide & Support',
                subtitle: 'Optical scanner troubleshooting & physician helpline',
                onTap: () => context.push(AppRoutes.doctorHelp),
              ),
              const SizedBox(height: 16),

              // Sign Out Doctor
              InkWell(
                onTap: () {
                  LogoutConfirmationDialog.show(
                    context,
                    onConfirmLogout: () {
                      ref.read(authProvider.notifier).signOut();
                      context.go(AppRoutes.roleSelection);
                    },
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.logout_rounded, color: AppColors.coralError, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sign Out of Doctor Portal',
                          style: AppStyles.bodyMedium.copyWith(color: AppColors.coralError, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.coralError),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorStat extends StatelessWidget {
  final String label;
  final String value;

  const _DoctorStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.medicalBlue),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _DoctorMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DoctorMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle, width: 1.2),
          boxShadow: AppStyles.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.medicalBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppStyles.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
