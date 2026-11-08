import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class DoctorNotificationsScreen extends StatefulWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  State<DoctorNotificationsScreen> createState() => _DoctorNotificationsScreenState();
}

class _DoctorNotificationsScreenState extends State<DoctorNotificationsScreen> {
  bool _queueArrivals = true;
  bool _criticalLabs = true;
  bool _emergencyTriage = true;
  bool _dailySummary = true;

  @override
  Widget build(BuildContext context) {
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
            Text('Doctor Notification Settings', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Queue Alerts & Clinical Escalations',
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
            Text('Clinical Escalation Alerts', style: AppStyles.heading3.copyWith(fontSize: 15)),
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
                      title: const Text('Critical Abnormal Lab Alerts (STAT)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      subtitle: const Text('Instant notification when pathology center marks panic-range parameters', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      value: _criticalLabs,
                      activeTrackColor: AppColors.medicalBlue,
                      onChanged: (val) => setState(() => _criticalLabs = val),
                    ),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    SwitchListTile(
                      title: const Text('Emergency Triaging Alert', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      subtitle: const Text('Sound urgent chime when incoming patient reports acute chest pain or severe distress', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      value: _emergencyTriage,
                      activeTrackColor: AppColors.medicalBlue,
                      onChanged: (val) => setState(() => _emergencyTriage = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('OPD Queue Alerts', style: AppStyles.heading3.copyWith(fontSize: 15)),
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
                      title: const Text('New Patient Queue Check-In', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      subtitle: const Text('Notify when nurse checks in a new patient with token assignment', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      value: _queueArrivals,
                      activeTrackColor: AppColors.medicalBlue,
                      onChanged: (val) => setState(() => _queueArrivals = val),
                    ),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    SwitchListTile(
                      title: const Text('End-of-Session Daily Digest', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      subtitle: const Text('Email comprehensive list of completed OPD consultations and written prescriptions', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      value: _dailySummary,
                      activeTrackColor: AppColors.medicalBlue,
                      onChanged: (val) => setState(() => _dailySummary = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
