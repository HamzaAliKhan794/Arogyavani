import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/medical_records_provider.dart';

class ShareConfigurationScreen extends ConsumerStatefulWidget {
  const ShareConfigurationScreen({super.key});

  @override
  ConsumerState<ShareConfigurationScreen> createState() => _ShareConfigurationScreenState();
}

class _ShareConfigurationScreenState extends ConsumerState<ShareConfigurationScreen> {
  late bool _shareSoap;
  late bool _shareComplaints;
  late bool _shareVisits;
  late bool _shareLabs;
  late bool _shareRx;
  late bool _shareDocs;
  late int _durationMinutes;

  @override
  void initState() {
    super.initState();
    final session = ref.read(medicalRecordsProvider).activeShareSession;
    _shareSoap = session.shareSoapSummary;
    _shareComplaints = session.shareChiefComplaints;
    _shareVisits = session.shareRecentVisits;
    _shareLabs = session.shareLabReports;
    _shareRx = session.sharePrescriptions;
    _shareDocs = session.shareUploadedDocuments;
    _durationMinutes = session.totalDuration.inMinutes;
  }

  void _handleSaveConfig() {
    ref.read(medicalRecordsProvider.notifier).configureShareOptions(
          shareSoapSummary: _shareSoap,
          shareChiefComplaints: _shareComplaints,
          shareRecentVisits: _shareVisits,
          shareLabReports: _shareLabs,
          sharePrescriptions: _shareRx,
          shareUploadedDocuments: _shareDocs,
          duration: Duration(minutes: _durationMinutes),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Doctor permissions updated for $_durationMinutes minutes.'),
        backgroundColor: AppColors.primaryTeal,
        duration: const Duration(seconds: 2),
      ),
    );

    context.pop();
  }

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
            Text('Configure Doctor Access', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Select data visible to consulting physician',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Granular Permissions
                    Text('Select Health Data to Share:', style: AppStyles.heading3.copyWith(fontSize: 15)),
                    const SizedBox(height: 10),

                    _PermissionSwitchCard(
                      title: 'AI Clinical Voice SOAP Summary',
                      subtitle: 'Transcribed symptoms, HPI narrative & provisional recommendations',
                      icon: Icons.auto_awesome_rounded,
                      value: _shareSoap,
                      onChanged: (val) => setState(() => _shareSoap = val),
                    ),
                    const SizedBox(height: 8),

                    _PermissionSwitchCard(
                      title: 'Chief Complaints & Known Allergies',
                      subtitle: 'Critical allergy flags, drug sensitivities & current symptoms',
                      icon: Icons.shield_outlined,
                      value: _shareComplaints,
                      onChanged: (val) => setState(() => _shareComplaints = val),
                    ),
                    const SizedBox(height: 8),

                    _PermissionSwitchCard(
                      title: 'Recent OPD Visits (Past 30 Days)',
                      subtitle: 'Previous hospital visits, diagnosis and consulting doctor notes',
                      icon: Icons.assignment_outlined,
                      value: _shareVisits,
                      onChanged: (val) => setState(() => _shareVisits = val),
                    ),
                    const SizedBox(height: 8),

                    _PermissionSwitchCard(
                      title: 'Lab & Diagnostic Reports',
                      subtitle: 'Blood tests, pathology findings, and radiology reports',
                      icon: Icons.biotech_outlined,
                      value: _shareLabs,
                      onChanged: (val) => setState(() => _shareLabs = val),
                    ),
                    const SizedBox(height: 8),

                    _PermissionSwitchCard(
                      title: 'Active Prescriptions & Medications',
                      subtitle: 'Current dosage schedule, duration and medication history',
                      icon: Icons.medication_outlined,
                      value: _shareRx,
                      onChanged: (val) => setState(() => _shareRx = val),
                    ),
                    const SizedBox(height: 8),

                    _PermissionSwitchCard(
                      title: 'Uploaded Scans & Past Vault Records',
                      subtitle: 'External PDFs, historical discharge summaries & uploaded images',
                      icon: Icons.folder_open_rounded,
                      value: _shareDocs,
                      onChanged: (val) => setState(() => _shareDocs = val),
                    ),
                    const SizedBox(height: 24),

                    // Section 2: Session Duration
                    Text('Session Expiry Duration:', style: AppStyles.heading3.copyWith(fontSize: 15)),
                    const SizedBox(height: 10),

                    _DurationOptionTile(
                      title: '15 Minutes',
                      badge: 'Recommended for OPD',
                      description: 'Auto-expires right after standard consultation concludes',
                      isSelected: _durationMinutes == 15,
                      onTap: () => setState(() => _durationMinutes = 15),
                    ),
                    const SizedBox(height: 8),

                    _DurationOptionTile(
                      title: '1 Hour',
                      badge: 'Specialist Evaluation',
                      description: 'Extended window for multi-department examinations',
                      isSelected: _durationMinutes == 60,
                      onTap: () => setState(() => _durationMinutes = 60),
                    ),
                    const SizedBox(height: 8),

                    _DurationOptionTile(
                      title: '24 Hours',
                      badge: 'Day Care / Admission',
                      description: 'Allows hospital care team periodic record access for 24h',
                      isSelected: _durationMinutes == 1440,
                      onTap: () => setState(() => _durationMinutes = 1440),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Update Button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: PrimaryButton(
                text: 'Update & Generate Secure QR Pass',
                icon: Icons.qr_code_rounded,
                onPressed: _handleSaveConfig,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionSwitchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PermissionSwitchCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? AppColors.medicalBlue.withValues(alpha: 0.3) : AppColors.borderSubtle,
          width: 1.2,
        ),
        boxShadow: AppStyles.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                Text(
                  title,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppStyles.bodySmall.copyWith(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.medicalBlue,
          ),
        ],
      ),
    );
  }
}

class _DurationOptionTile extends StatelessWidget {
  final String title;
  final String badge;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationOptionTile({
    required this.title,
    required this.badge,
    required this.description,
    required this.isSelected,
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
          color: isSelected ? const Color(0xFFEFF6FF) : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.medicalBlue : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: AppStyles.cardShadow,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.medicalBlue : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppStyles.heading3.copyWith(
                          fontSize: 14.5,
                          color: isSelected ? AppColors.medicalBlue : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppColors.medicalBlue : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppStyles.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
