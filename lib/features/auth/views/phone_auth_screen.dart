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
import '../../../core/widgets/phone_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/security_lock_footer.dart';
import '../../../core/widgets/step_dots_indicator.dart';
import '../providers/auth_provider.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  final bool isSignUp;

  const PhoneAuthScreen({
    super.key,
    this.isSignUp = false,
  });

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  late final TextEditingController _phoneController;
  late bool _isSignUp;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isSignUp;
    // Pre-populate realistic test number from MediAssist screenshot: 9955739705
    _phoneController = TextEditingController(text: '9955739705');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleGetCode() async {
    final phone = _phoneController.text.trim();
    final success = await ref.read(authProvider.notifier).sendOtp(phone);
    if (success && mounted) {
      context.push(AppRoutes.otpVerification);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Header
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
                      'Back',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                  ArogyavaniBadge.patient(),
                ],
              ),
              const SizedBox(height: 16),
              // Step Dots
              const StepDotsIndicator(totalSteps: 3, currentStep: 0),
              const SizedBox(height: 24),
              // Centered Main Card
              Expanded(
                child: SingleChildScrollView(
                  child: ArogyavaniCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _isSignUp ? 'Create Patient Account' : AppStrings.signInWithMobile,
                          style: AppStyles.heading2.copyWith(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isSignUp
                              ? 'Enter your mobile number to register your health ID'
                              : AppStrings.enterMobileNumber,
                          style: AppStyles.subtitle.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Development Notice Banner
                        const DevModeBanner(
                          message: AppStrings.devModeWarning,
                        ),
                        const SizedBox(height: 24),
                        // Phone input
                        PhoneTextField(
                          controller: _phoneController,
                          errorText: authState.errorMessage,
                          onSubmitted: _handleGetCode,
                        ),
                        const SizedBox(height: 22),
                        // Primary CTA
                        PrimaryButton(
                          text: AppStrings.getVerificationCode,
                          isLoading: authState.isLoading,
                          onPressed: _handleGetCode,
                        ),
                        const SizedBox(height: 18),
                        // Mode switcher
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSignUp ? 'Already registered?' : AppStrings.newToArogyavani,
                              style: AppStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                });
                              },
                              child: Text(
                                _isSignUp ? 'Sign In' : AppStrings.createAnAccount,
                                style: AppStyles.bodySmall.copyWith(
                                  color: AppColors.medicalBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SecurityLockFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
