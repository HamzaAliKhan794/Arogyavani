import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/arogyavani_badge.dart';
import '../../../core/widgets/arogyavani_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/security_lock_footer.dart';
import '../../../core/widgets/step_dots_indicator.dart';
import '../../../core/widgets/test_otp_banner.dart';
import '../providers/auth_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  late final TextEditingController _otpController;
  Timer? _resendTimer;
  int _secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startResendTimer();
  }

  void _startResendTimer() {
    _secondsRemaining = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final otp = _otpController.text.trim();
    final success = await ref.read(authProvider.notifier).verifyOtp(otp);
    if (success && mounted) {
      context.go(AppRoutes.patientDashboard);
    }
  }

  void _autoFillOtp(String code) {
    setState(() {
      _otpController.text = code;
    });
    _handleVerify();
  }

  void _handleResend() {
    if (_secondsRemaining > 0) return;
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test code resent: 918957'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final phone = authState.phoneNumber ?? '9955739705';
    final testOtp = authState.devTestOtp ?? '918957';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
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
                      'Change Phone',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                  ArogyavaniBadge.patient(),
                ],
              ),
              const SizedBox(height: 16),
              // Step Dots (Step 2 active)
              const StepDotsIndicator(totalSteps: 3, currentStep: 1),
              const SizedBox(height: 24),
              // Main Verification Card
              Expanded(
                child: SingleChildScrollView(
                  child: ArogyavaniCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppStrings.verifyCode,
                          style: AppStyles.heading2.copyWith(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppStyles.subtitle.copyWith(fontSize: 14),
                            children: [
                              TextSpan(text: 'Enter the 6-digit code for +91 $phone '),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Text(
                                    'Change',
                                    style: AppStyles.bodySmall.copyWith(
                                      color: AppColors.medicalBlue,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Interactive Test OTP Banner
                        TestOtpBanner(
                          otpCode: testOtp,
                          onAutoFill: () => _autoFillOtp(testOtp),
                        ),
                        const SizedBox(height: 24),
                        // Label
                        Text(
                          AppStrings.enter6DigitOtp,
                          style: AppStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // OTP Box
                        Container(
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: authState.errorMessage != null
                                  ? AppColors.coralError
                                  : AppColors.borderSubtle,
                              width: 1.2,
                            ),
                          ),
                          child: TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: AppStyles.heading2.copyWith(
                              letterSpacing: 10,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: AppColors.textPrimary,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: InputDecoration(
                              hintText: '• • • • • •',
                              hintStyle: AppStyles.heading2.copyWith(
                                letterSpacing: 8,
                                color: AppColors.textMuted,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onSubmitted: (_) => _handleVerify(),
                          ),
                        ),
                        if (authState.errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            authState.errorMessage!,
                            style: AppStyles.bodySmall.copyWith(
                              color: AppColors.coralError,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 24),
                        // Primary CTA
                        PrimaryButton(
                          text: AppStrings.verifyAndContinue,
                          isLoading: authState.isLoading,
                          onPressed: _handleVerify,
                        ),
                        const SizedBox(height: 20),
                        // Bottom Links: Back to Mobile & Resend Code
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Text(
                                AppStrings.backToMobile,
                                style: AppStyles.bodySmall.copyWith(
                                  color: AppColors.medicalBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _secondsRemaining == 0 ? _handleResend : null,
                              child: Text(
                                _secondsRemaining > 0
                                    ? 'Resend Code in ${_secondsRemaining}s'
                                    : AppStrings.resendCode,
                                style: AppStyles.bodySmall.copyWith(
                                  color: _secondsRemaining > 0
                                      ? AppColors.textMuted
                                      : AppColors.medicalBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
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
