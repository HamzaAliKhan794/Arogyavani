import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/arogyavani_badge.dart';
import '../../../core/widgets/global_state_views.dart';
import '../../../core/widgets/security_lock_footer.dart';
import '../../auth/providers/auth_provider.dart';
import '../../voice_intake/views/clinical_voice_intake_sheet.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/clinical_workflow_tracker.dart';
import '../widgets/dashboard_bottom_dock.dart';
import '../widgets/dashboard_modals.dart';
import '../widgets/explore_services_section.dart';
import '../widgets/hero_intake_card.dart';
import '../widgets/quick_access_grid.dart';

class PatientDashboardScreen extends ConsumerWidget {
  const PatientDashboardScreen({super.key});

  void _showIntakeEntryPoint(BuildContext context) {
    ClinicalVoiceIntakeSheet.show(context);
  }

  void _showAccountMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.medicalBlueSoft,
              child: const Text(
                'H',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.medicalBlue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('HAMZA', style: AppStyles.heading2.copyWith(fontSize: 18)),
            Text('+91 9955739705 · Patient ID: AR-9955', style: AppStyles.bodySmall),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded, color: AppColors.medicalBlue),
              title: Text('View Health Profile & Settings', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.patientProfile);
              },
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.coralError),
              title: Text('Sign Out', style: AppStyles.bodyMedium.copyWith(color: AppColors.coralError)),
              onTap: () {
                Navigator.pop(context);
                LogoutConfirmationDialog.show(
                  context,
                  onConfirmLogout: () {
                    ref.read(authProvider.notifier).signOut();
                    context.go(AppRoutes.roleSelection);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);
    final authState = ref.watch(authProvider);
    final userName = authState.userName.isNotEmpty ? authState.userName : 'HAMZA';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 16),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppStrings.appName,
                style: AppStyles.heading3.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondarySurface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                'OPD',
                style: AppStyles.badgeText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ArogyavaniBadge.opdLive(),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _showAccountMenu(context, ref),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.medicalBlueSoft,
              child: Text(
                userName[0],
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.medicalBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Personalised Welcome Section & ABHA Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${dashboardState.greeting}, $userName 👋',
                          style: AppStyles.heading1.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.aiClinicalIntakeHub,
                          style: AppStyles.subtitle.copyWith(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ABHA Connection Status Indicator
                  GestureDetector(
                    onTap: () => DashboardModals.showAbhaDetails(context),
                    child: ArogyavaniBadge.abhaReady(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Hero AI Clinical Intake Card
              HeroIntakeCard(
                onStartIntake: () => _showIntakeEntryPoint(context),
              ),
              const SizedBox(height: 24),

              // 3. Quick Access Grid
              QuickAccessGrid(
                onOpdVisitsTap: () {
                  if (GoRouter.maybeOf(context) != null) {
                    context.push(AppRoutes.opdVisitsHistory);
                  } else {
                    DashboardModals.showOpdVisitsModal(context);
                  }
                },
                onLabReportsTap: () {
                  if (GoRouter.maybeOf(context) != null) {
                    context.push(AppRoutes.labReports);
                  } else {
                    DashboardModals.showLabReportsModal(context);
                  }
                },
                onRxRecordsTap: () {
                  if (GoRouter.maybeOf(context) != null) {
                    context.push(AppRoutes.prescriptionRecords);
                  } else {
                    DashboardModals.showRxRecordsModal(context);
                  }
                },
                onDoctorQrTap: () {
                  if (GoRouter.maybeOf(context) != null) {
                    context.push(AppRoutes.doctorQr);
                  } else {
                    DashboardModals.showDoctorQrModal(context);
                  }
                },
              ),
              const SizedBox(height: 24),

              // 4. Four-Stage Clinical Workflow Tracker
              ClinicalWorkflowTracker(
                currentStep: dashboardState.currentWorkflowStep,
                onStepTap: (step) {
                  ref.read(dashboardProvider.notifier).setWorkflowStep(step);
                  final router = GoRouter.maybeOf(context);
                  if (router != null) {
                    if (step == 1) {
                      _showIntakeEntryPoint(context);
                    } else if (step == 2) {
                      context.push(AppRoutes.medicalRecords);
                    } else if (step == 3) {
                      context.push(AppRoutes.clinicalReport);
                    } else if (step == 4) {
                      context.push(AppRoutes.doctorQr);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Workflow active: Stage $step'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // 5. Explore Arogyavani Collapsible Section
              ExploreServicesSection(
                isExpanded: dashboardState.isExploreExpanded,
                onToggle: () => ref.read(dashboardProvider.notifier).toggleExploreExpanded(),
                onServiceTap: (service) => DashboardModals.showServiceDetail(context, service),
              ),
              const SizedBox(height: 16),

              // 6. Security & Trust Footer
              const SecurityLockFooter(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      // 7. Fixed Bottom Navigation Dock with Central Mic Button
      bottomNavigationBar: DashboardBottomDock(
        activeIndex: dashboardState.activeTab,
        onTabSelected: (index) {
          ref.read(dashboardProvider.notifier).setActiveTab(index);
          if (index == 1) {
            if (GoRouter.maybeOf(context) != null) {
              context.push(AppRoutes.opdVisitsHistory);
            } else {
              DashboardModals.showOpdVisitsModal(context);
            }
          } else if (index == 2) {
            if (GoRouter.maybeOf(context) != null) {
              context.push(AppRoutes.medicalRecords);
            } else {
              DashboardModals.showLabReportsModal(context);
            }
          } else if (index == 3) {
            _showAccountMenu(context, ref);
          }
        },
        onMicPressed: () => _showIntakeEntryPoint(context),
      ),
    );
  }
}
