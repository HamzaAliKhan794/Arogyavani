import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/arogyavani_badge.dart';
import '../../../core/widgets/arogyavani_card.dart';
import '../../../core/widgets/security_lock_footer.dart';

class PatientPortalScreen extends StatelessWidget {
  const PatientPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.chevron_left_rounded, size: 22),
                    label: const Text(
                      AppStrings.changeRole,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                  ArogyavaniBadge.patientPortal(),
                ],
              ),
              const SizedBox(height: 36),
              // Titles
              Center(
                child: Column(
                  children: [
                    Text(
                      AppStrings.patientAccount,
                      style: AppStyles.heading1.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.patientAccountSubtitle,
                      style: AppStyles.subtitle.copyWith(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              // Card 1: Sign In
              ArogyavaniCard(
                onTap: () => context.push('${AppRoutes.phoneAuth}?mode=signin'),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.medicalBlueSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.login_rounded,
                        color: AppColors.medicalBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.signIn,
                            style: AppStyles.heading3.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.signInDesc,
                            style: AppStyles.bodySmall.copyWith(
                              height: 1.35,
                              color: AppColors.textSecondary,
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
              // Card 2: Create Account
              ArogyavaniCard(
                onTap: () => context.push('${AppRoutes.phoneAuth}?mode=signup'),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.medicalBlueSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: AppColors.medicalBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.createAccount,
                            style: AppStyles.heading3.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.createAccountDesc,
                            style: AppStyles.bodySmall.copyWith(
                              height: 1.35,
                              color: AppColors.textSecondary,
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
