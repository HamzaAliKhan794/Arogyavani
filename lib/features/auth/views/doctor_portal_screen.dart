import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/arogyavani_badge.dart';
import '../../../core/widgets/arogyavani_card.dart';
import '../../../core/widgets/dev_mode_banner.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/security_lock_footer.dart';
import '../models/user_role.dart';
import '../providers/auth_provider.dart';

class DoctorPortalScreen extends ConsumerStatefulWidget {
  const DoctorPortalScreen({super.key});

  @override
  ConsumerState<DoctorPortalScreen> createState() => _DoctorPortalScreenState();
}

class _DoctorPortalScreenState extends ConsumerState<DoctorPortalScreen> {
  late final TextEditingController _licenseController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _licenseController = TextEditingController(text: 'MCI-88421-DEL');
  }

  @override
  void dispose() {
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _handleDoctorSignIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    ref.read(authProvider.notifier).selectRole(UserRole.doctor);
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.doctorDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
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
                  ArogyavaniBadge.doctorPortal(),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Doctor Portal',
                      style: AppStyles.heading1.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Consultation queue & structured patient review',
                      style: AppStyles.subtitle.copyWith(fontSize: 14.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ArogyavaniCard(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DevModeBanner(
                      message: 'Pre-configured Clinician profile (Dr. R. Sharma, MD) loaded for evaluation.',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Doctor Registration / Medical License ID',
                      style: AppStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _licenseController,
                        style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Icon(Icons.verified_user_outlined, size: 20, color: AppColors.primaryTeal),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    PrimaryButton(
                      text: 'Enter Doctor Consultation Hub',
                      icon: Icons.login_rounded,
                      backgroundColor: AppColors.primaryTeal,
                      isLoading: _isLoading,
                      onPressed: _handleDoctorSignIn,
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
