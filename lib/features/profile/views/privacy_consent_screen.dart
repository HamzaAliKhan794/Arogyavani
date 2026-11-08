import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../providers/profile_provider.dart';

class PrivacyConsentScreen extends ConsumerWidget {
  const PrivacyConsentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consent = ref.watch(profileProvider).privacyConsent;
    final notifier = ref.read(profileProvider.notifier);

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
            Text('Privacy & Consent', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'ABDM Consent Manager & Clinical Privacy',
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
            // Trust & Security Notice Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.emeraldBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.emeraldSuccess, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Patient-First Data Sovereignty',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.emeraldSuccess),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'You maintain complete control over your clinical records. No hospital, doctor or laboratory can view your records without your explicit, time-limited cryptographic QR consent.',
                          style: AppStyles.bodySmall.copyWith(fontSize: 11.5, height: 1.4, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Active Consents
            Text('Active Healthcare Consents', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),

            _ConsentSwitchCard(
              title: 'ABDM Health Information Exchange (HIE)',
              subtitle: 'Allow verified diagnostic labs and hospitals to link records with your ABHA ID',
              icon: Icons.hub_outlined,
              value: consent.abhaGatewayConsent,
              onChanged: (val) => notifier.updatePrivacyConsent(abhaGatewayConsent: val),
            ),
            const SizedBox(height: 10),

            _ConsentSwitchCard(
              title: 'AI Clinical Voice Scribe Processing',
              subtitle: 'Allow on-device speech-to-text to structure Chief Complaints & HPI summaries',
              icon: Icons.mic_none_rounded,
              value: consent.aiVoiceProcessingConsent,
              onChanged: (val) => notifier.updatePrivacyConsent(aiVoiceProcessingConsent: val),
            ),
            const SizedBox(height: 10),

            _ConsentSwitchCard(
              title: 'Automatic Doctor QR Pass Invalidation',
              subtitle: 'Automatically terminate doctor access passes as soon as consultation concludes',
              icon: Icons.timer_off_outlined,
              value: consent.autoRevokeDoctorQr,
              onChanged: (val) => notifier.updatePrivacyConsent(autoRevokeDoctorQr: val),
            ),
            const SizedBox(height: 10),

            _ConsentSwitchCard(
              title: 'Anonymized Clinical Research Contribution',
              subtitle: 'Help medical research by donating de-identified symptom telemetry (Opt-in only)',
              icon: Icons.science_outlined,
              value: consent.anonymizedResearchConsent,
              onChanged: (val) => notifier.updatePrivacyConsent(anonymizedResearchConsent: val),
            ),
            const SizedBox(height: 24),

            // Data Rights & Portability
            Text('Data Portability & Audit Rights', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generating encrypted Health Archive (FHIR / JSON)... Download ready in 3s.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Download My Health Archive (JSON / FHIR)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.medicalBlue,
                side: const BorderSide(color: AppColors.medicalBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                notifier.updatePrivacyConsent(
                  abhaGatewayConsent: false,
                  aiVoiceProcessingConsent: false,
                  anonymizedResearchConsent: false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All third-party data sharing consents have been revoked.'),
                    backgroundColor: AppColors.coralError,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.block_rounded, size: 18, color: AppColors.coralError),
              label: const Text('Revoke All Active Consents', style: TextStyle(color: AppColors.coralError)),
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

class _ConsentSwitchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ConsentSwitchCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle, width: 1.2),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: value ? AppColors.medicalBlue : AppColors.textMuted, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppStyles.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary, height: 1.35)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: AppColors.medicalBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
