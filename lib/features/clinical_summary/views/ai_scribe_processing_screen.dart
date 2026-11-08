import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../providers/clinical_report_provider.dart';

class AiScribeProcessingScreen extends ConsumerStatefulWidget {
  const AiScribeProcessingScreen({super.key});

  @override
  ConsumerState<AiScribeProcessingScreen> createState() => _AiScribeProcessingScreenState();
}

class _AiScribeProcessingScreenState extends ConsumerState<AiScribeProcessingScreen> {
  int _activeStage = 1;
  Timer? _step1Timer;
  Timer? _step2Timer;
  Timer? _step3Timer;

  @override
  void initState() {
    super.initState();
    _startPipeline();
  }

  void _startPipeline() {
    // Step 1: Audio Upload Received (completes at 700ms)
    _step1Timer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _activeStage = 2);
    });

    // Step 2: Faster-Whisper Speech-to-Text (completes at 1500ms)
    _step2Timer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _activeStage = 3);
    });

    // Step 3: Structuring Chief Complaints & Allergies (completes at 2300ms)
    _step3Timer = Timer(const Duration(milliseconds: 2300), () {
      if (mounted) {
        setState(() => _activeStage = 4);
        ref.read(clinicalReportProvider.notifier).setProcessingStage(4);
        // Automatic navigation to the Doctor-Ready Report Screen (Image 11 & 14)
        if (GoRouter.maybeOf(context) != null) {
          context.pushReplacement(AppRoutes.clinicalReport);
        }
      }
    });
  }

  @override
  void dispose() {
    _step1Timer?.cancel();
    _step2Timer?.cancel();
    _step3Timer?.cancel();
    super.dispose();
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
            Text(
              'Doctor-Ready Clinical Report',
              style: AppStyles.heading3.copyWith(fontSize: 16),
            ),
            Text(
              'OPD Consultation',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() => _activeStage = 1);
              _startPipeline();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated Circular Progress Indicator (Matches Image 13)
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEFF6FF),
                  border: Border.all(
                    color: const Color(0xFFDBEAFE),
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.medicalBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Heading
              Text(
                'AI Medical Scribe Active',
                style: AppStyles.heading1.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Processing Description
              Text(
                'Faster-Whisper is translating your audio &\nextracting clinical SOAP findings...',
                style: AppStyles.subtitle.copyWith(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Three-stage Animated Checklist (Matches Screenshot 5)
              Center(
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChecklistStep(
                        stepNumber: 1,
                        label: 'Audio Upload Received',
                        isCompleted: _activeStage > 1,
                        isActive: _activeStage == 1,
                      ),
                      const SizedBox(height: 16),
                      _ChecklistStep(
                        stepNumber: 2,
                        label: 'Faster-Whisper Speech-to-Text',
                        isCompleted: _activeStage > 2,
                        isActive: _activeStage == 2,
                      ),
                      const SizedBox(height: 16),
                      _ChecklistStep(
                        stepNumber: 3,
                        label: 'Structuring Chief Complaints & Allergies',
                        isCompleted: _activeStage > 3,
                        isActive: _activeStage == 3,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistStep extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isCompleted;
  final bool isActive;

  const _ChecklistStep({
    required this.stepNumber,
    required this.label,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isCompleted)
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.emeraldSuccess,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 15,
              color: Colors.white,
            ),
          )
        else if (isActive)
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.medicalBlue),
            ),
          )
        else
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle, width: 1.5),
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        const SizedBox(width: 14),
        Text(
          '$stepNumber. $label',
          style: AppStyles.bodyMedium.copyWith(
            fontWeight: isCompleted || isActive ? FontWeight.w600 : FontWeight.w400,
            color: isCompleted
                ? AppColors.textPrimary
                : isActive
                    ? AppColors.medicalBlue
                    : AppColors.textSecondary,
            fontSize: 14.5,
          ),
        ),
      ],
    );
  }
}
