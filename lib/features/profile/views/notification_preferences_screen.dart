import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../providers/profile_provider.dart';

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(profileProvider).notificationPreferences;
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
            Text('Notification Preferences', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Manage reminders & OPD queue alerts',
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
            // Status Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active_rounded, color: AppColors.medicalBlue, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Push Notifications Enabled', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('Instant alerts will be delivered to this device', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Clinical Consultation Alerts
            Text('Consultation & Medical Alerts', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            _NotificationToggleCard(
              title: 'OPD Queue Turn Alerts',
              subtitle: 'Sound an alert when your token is called to the doctor\'s consultation room',
              icon: Icons.confirmation_number_outlined,
              value: prefs.queueTurnAlerts,
              onChanged: (val) => notifier.updateNotificationPreferences(queueTurnAlerts: val),
            ),
            const SizedBox(height: 8),

            _NotificationToggleCard(
              title: 'Pill & Medication Reminders',
              subtitle: 'Daily scheduled notifications for morning, afternoon and night doses',
              icon: Icons.alarm_rounded,
              value: prefs.pillReminders,
              onChanged: (val) => notifier.updateNotificationPreferences(pillReminders: val),
            ),
            const SizedBox(height: 8),

            _NotificationToggleCard(
              title: 'Lab Report Ready Notifications',
              subtitle: 'Immediate alert when diagnostic center completes your blood test or scan',
              icon: Icons.biotech_outlined,
              value: prefs.labReportAlerts,
              onChanged: (val) => notifier.updateNotificationPreferences(labReportAlerts: val),
            ),
            const SizedBox(height: 24),

            // External Channels
            Text('External Alert Channels', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            _NotificationToggleCard(
              title: 'SMS Text Message Alerts',
              subtitle: 'Critical queue tokens, OTPs and emergency doctor notices sent via SMS',
              icon: Icons.sms_outlined,
              value: prefs.smsAlerts,
              onChanged: (val) => notifier.updateNotificationPreferences(smsAlerts: val),
            ),
            const SizedBox(height: 8),

            _NotificationToggleCard(
              title: 'WhatsApp Consultation Slip',
              subtitle: 'Receive PDF prescription slips and consultation summaries on WhatsApp',
              icon: Icons.chat_bubble_outline_rounded,
              value: prefs.whatsappAlerts,
              onChanged: (val) => notifier.updateNotificationPreferences(whatsappAlerts: val),
            ),
            const SizedBox(height: 8),

            _NotificationToggleCard(
              title: 'Weekly Health Insights Digest',
              subtitle: 'Email summary of vital trends, upcoming checkups and medicine refills',
              icon: Icons.email_outlined,
              value: prefs.emailDigest,
              onChanged: (val) => notifier.updateNotificationPreferences(emailDigest: val),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _NotificationToggleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            child: Icon(
              icon,
              size: 20,
              color: value ? AppColors.medicalBlue : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppStyles.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary, height: 1.3)),
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
