import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../providers/profile_provider.dart';

class PatientAccountSettingsScreen extends ConsumerStatefulWidget {
  const PatientAccountSettingsScreen({super.key});

  @override
  ConsumerState<PatientAccountSettingsScreen> createState() => _PatientAccountSettingsScreenState();
}

class _PatientAccountSettingsScreenState extends ConsumerState<PatientAccountSettingsScreen> {
  bool _biometricLock = true;
  bool _otpVaultAccess = true;

  void _showChangePhoneDialog() {
    final phoneCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Update Mobile Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A verification OTP will be sent to your new mobile number before updating your health account.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixText: '+91 ',
                labelText: 'New Mobile Number',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Development Mode: Phone update simulated.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Send Verification'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(profileProvider).patientProfile;

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
            Text('Account Settings', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Security, ABHA & System Preferences',
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
            // Registered Phone Section
            Text('Authentication & Mobile', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
                    child: const Icon(Icons.phone_android_rounded, color: AppColors.medicalBlue, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(p.mobileNumber, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.emeraldBg,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text('Verified', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.emeraldSuccess)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Primary login & consultation token dispatch', style: AppStyles.bodySmall.copyWith(fontSize: 11.5)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _showChangePhoneDialog,
                    child: const Text('Change', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Government Health Identifiers
            Text('National Digital Health (ABDM)', style: AppStyles.heading3.copyWith(fontSize: 15)),
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
                        child: const Icon(Icons.credit_card_rounded, color: AppColors.medicalBlue, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ABHA ID: ${p.abhaId}', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                            Text('ABHA Address: ${p.abhaAddress}', style: AppStyles.bodySmall.copyWith(color: AppColors.medicalBlue, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_rounded, color: AppColors.emeraldSuccess, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.health_and_safety_outlined, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ayushman Bharat PM-JAY', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('Not linked yet', style: AppStyles.bodySmall.copyWith(fontSize: 11)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Checking PM-JAY eligibility with ABHA number...')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text('Link', style: TextStyle(fontSize: 11.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Security & App Lock
            Text('Security & Biometrics', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Biometric / Screen Lock', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Require fingerprint or Face Unlock to open Arogyavani', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      value: _biometricLock,
                      activeTrackColor: AppColors.medicalBlue,
                      onChanged: (val) => setState(() => _biometricLock = val),
                    ),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    SwitchListTile(
                      title: const Text('Two-Factor Vault Protection', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Require OTP before downloading full PDF medical archive', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      value: _otpVaultAccess,
                      activeTrackColor: AppColors.medicalBlue,
                      onChanged: (val) => setState(() => _otpVaultAccess = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Danger Zone
            Text('Storage & Data Management', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Local cache cleared successfully. 12 MB freed.')),
                );
              },
              icon: const Icon(Icons.cleaning_services_rounded, size: 16),
              label: const Text('Clear Temporary Cache (12 MB)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Deactivate Vault'),
                    content: const Text('This will delete all offline medical records stored on this device. Your government ABHA record remains unaffected.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.coralError),
                        child: const Text('Confirm Deactivate'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.coralError),
              label: const Text('Deactivate Local Medical Vault', style: TextStyle(color: AppColors.coralError)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFECACA)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
