import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/global_state_views.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class PatientProfileScreen extends ConsumerWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final p = state.patientProfile;

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
            Text('My Health Profile', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Patient ID: AR-9955 · ABDM Verified',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            icon: const Icon(Icons.edit_outlined, color: AppColors.medicalBlue),
            onPressed: () => context.push(AppRoutes.patientEditProfile),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Profile Summary Card
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
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.medicalBlueSoft,
                          child: Text(
                            p.fullName.isNotEmpty ? p.fullName[0] : 'H',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.medicalBlue,
                            ),
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
                                      p.fullName,
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
                                      'ABHA Ready',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.emeraldSuccess,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${p.gender}, ${p.age} yrs · ${p.mobileNumber}',
                                style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              // ABHA ID Pill with Copy
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: p.abhaId));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ABHA ID copied to clipboard'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'ABHA: ${p.abhaId}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.copy_rounded, size: 12, color: AppColors.textMuted),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: 14),

                    // Vitals Quick Grid
                    Row(
                      children: [
                        _VitalMetricTile(label: 'Blood Group', value: p.bloodGroup),
                        _VitalMetricTile(label: 'Age', value: '${p.age} Yrs'),
                        _VitalMetricTile(label: 'Height', value: '${p.heightCm.toInt()} cm'),
                        _VitalMetricTile(label: 'Weight', value: '${p.weightKg.toInt()} kg'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Emergency Contact Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppStyles.cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.coralError, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Emergency Contact', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('${p.emergencyContactName} · ${p.emergencyContactPhone}', style: AppStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Settings Section
              Text('Account & Preferences', style: AppStyles.heading3.copyWith(fontSize: 15)),
              const SizedBox(height: 10),

              _SettingsMenuTile(
                icon: Icons.person_outline_rounded,
                title: 'Edit Personal Information',
                subtitle: 'Name, email, gender, emergency contact & address',
                onTap: () => context.push(AppRoutes.patientEditProfile),
              ),
              const SizedBox(height: 8),

              _SettingsMenuTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Account Settings & ABHA',
                subtitle: 'Manage phone, linked ABHA card & app security',
                onTap: () => context.push(AppRoutes.patientSettings),
              ),
              const SizedBox(height: 8),

              _SettingsMenuTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notification Preferences',
                subtitle: 'OPD queue turns, pill reminders & lab alerts',
                onTap: () => context.push(AppRoutes.notificationPreferences),
              ),
              const SizedBox(height: 8),

              _SettingsMenuTile(
                icon: Icons.language_rounded,
                title: 'Language & Speech Preferences',
                subtitle: 'App display language & AI voice intake dialect',
                onTap: () => context.push(AppRoutes.languagePreferences),
              ),
              const SizedBox(height: 8),

              _SettingsMenuTile(
                icon: Icons.security_rounded,
                title: 'Privacy, Consent & Data Vault',
                subtitle: 'ABDM data sharing permissions & audit trail',
                onTap: () => context.push(AppRoutes.privacyConsent),
              ),
              const SizedBox(height: 8),

              _SettingsMenuTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Clinical Helpline',
                subtitle: 'FAQs, patient guide & 24/7 National Health line (1075)',
                onTap: () => context.push(AppRoutes.helpSupport),
              ),
              const SizedBox(height: 14),

              // Sign Out Tile
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
                          'Sign Out of Arogyavani',
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppColors.coralError,
                            fontWeight: FontWeight.w700,
                          ),
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

class _VitalMetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _VitalMetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.medicalBlue,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppStyles.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsMenuTile({
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
