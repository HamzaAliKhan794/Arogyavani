import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/primary_button.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../models/clinical_report_model.dart';
import '../providers/clinical_report_provider.dart';
import '../widgets/chief_complaint_chip.dart';
import '../widgets/clinical_plan_card.dart';
import '../widgets/expandable_transcript_card.dart';
import '../widgets/physician_disclaimer_banner.dart';

class ClinicalReportScreen extends ConsumerWidget {
  const ClinicalReportScreen({super.key});

  void _handleDone(BuildContext context, WidgetRef ref) {
    // 1. Advance Clinical Workflow to Step 3 (Summary completed / Step 4 Doctor consultation ready)
    ref.read(dashboardProvider.notifier).setWorkflowStep(3);

    // 2. Return to Patient Dashboard
    context.go(AppRoutes.patientDashboard);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clinical Summary saved. Doctor can now review your health story.'),
        backgroundColor: AppColors.primaryTeal,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(clinicalReportProvider);
    final report = reportState.currentReport;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.patientDashboard),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor-Ready Clinical Report',
              style: AppStyles.heading3.copyWith(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              report.tokenNumber,
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          // Switch between Sample 1 (Hamzali), Sample 2 (Tavish), and Sample 3 (Cristiano) for testing
          IconButton(
            tooltip: 'Toggle Sample Report (Token #12 / #13 / #14)',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              final ClinicalReportModel newSample;
              if (report.tokenNumber == 'Token #12') {
                newSample = ClinicalReportModel.sampleTavish();
              } else if (report.tokenNumber == 'Token #13') {
                newSample = ClinicalReportModel.sampleCristiano();
              } else {
                newSample = ClinicalReportModel.sampleHamzali();
              }
              ref.read(clinicalReportProvider.notifier).setReport(newSample);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched to ${newSample.patientSpokenName} (${newSample.tokenNumber})'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Clinical Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Mandatory Physician Review Banner
                    const PhysicianDisclaimerBanner(),
                    const SizedBox(height: 16),

                    // 2. Chief Complaint Chips (Matches Image 11 & 14)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: report.chiefComplaints
                          .map((complaint) => ChiefComplaintChip(label: complaint))
                          .toList(),
                    ),
                    const SizedBox(height: 18),

                    // 3. History of Present Illness (HPI)
                    Text(
                      'History of Present Illness (HPI):',
                      style: AppStyles.heading3.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
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
                          Text(
                            report.hpiNarrative,
                            style: AppStyles.bodyRegular.copyWith(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: AppColors.borderSubtle),
                          const SizedBox(height: 12),
                          // Allergies & Medications
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.shield_outlined, size: 16, color: AppColors.medicalBlue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Allergies: ${report.knownAllergies}',
                                  style: AppStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4. A & P — Clinical Plan & Recommendations Card (Matches Image 11 & 14)
                    ClinicalPlanCard(
                      provisionalAssessment: report.provisionalAssessment,
                      recommendedActions: report.recommendedActions,
                    ),
                    const SizedBox(height: 20),

                    // 5. Expandable Original Spoken Transcript (Matches Image 11 & 12)
                    ExpandableTranscriptCard(
                      transcript: report.originalTranscript,
                      isExpanded: reportState.isTranscriptExpanded,
                      onToggle: () => ref.read(clinicalReportProvider.notifier).toggleTranscript(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // PART 3: Sticky Bottom Action (Matches Image 12)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                border: const Border(
                  top: BorderSide(color: AppColors.borderSubtle, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: PrimaryButton(
                text: 'Done & Return to Dashboard',
                height: 52,
                borderRadius: 14,
                onPressed: () => _handleDone(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
