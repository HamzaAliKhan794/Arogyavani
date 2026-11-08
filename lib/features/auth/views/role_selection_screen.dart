import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/arogyavani_card.dart';
import '../../../core/widgets/security_lock_footer.dart';
import '../models/user_role.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            children: [
              const SizedBox(height: 14),
              // Brand Badge Pill (matches image 2)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(AppStyles.radiusPill),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: AppStyles.cardShadow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.medicalBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 14,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.appName,
                        style: AppStyles.heading3.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 42),
              // Heading
              Text(
                AppStrings.continueAs,
                style: AppStyles.heading1.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.selectPortal,
                style: AppStyles.subtitle.copyWith(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              // Patient Portal Card
              ArogyavaniCard(
                onTap: () {
                  ref.read(authProvider.notifier).selectRole(UserRole.patient);
                  context.push(AppRoutes.patientPortal);
                },
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.medicalBlueSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.medicalBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.imPatient,
                            style: AppStyles.heading3.copyWith(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.patientDesc,
                            style: AppStyles.bodySmall.copyWith(
                              height: 1.4,
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Doctor Portal Card
              ArogyavaniCard(
                onTap: () {
                  ref.read(authProvider.notifier).selectRole(UserRole.doctor);
                  context.push(AppRoutes.doctorPortal);
                },
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.medicalBlueSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.medical_services_outlined,
                        color: AppColors.medicalBlue,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.imDoctor,
                            style: AppStyles.heading3.copyWith(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.doctorDesc,
                            style: AppStyles.bodySmall.copyWith(
                              height: 1.4,
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SecurityLockFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
