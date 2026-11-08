import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';

class ClinicalWorkflowTracker extends StatelessWidget {
  final int currentStep; // 1 to 4
  final ValueChanged<int>? onStepTap;

  const ClinicalWorkflowTracker({
    super.key,
    required this.currentStep,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    const steps = [
      AppStrings.stepSymptoms,
      AppStrings.stepReports,
      AppStrings.stepSummary,
      AppStrings.stepDoctor,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppStrings.clinicalWorkflow,
                  style: AppStyles.badgeText.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Step $currentStep of ${steps.length}',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Symmetrical Responsive Stepper
          Row(
            children: List.generate(steps.length, (index) {
              final stepNumber = index + 1;
              final isCurrent = stepNumber == currentStep;
              final isCompleted = stepNumber < currentStep;
              final stepLabel = steps[index];

              return Expanded(
                child: InkWell(
                  onTap: () => onStepTap?.call(stepNumber),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: index == 0
                                  ? Colors.transparent
                                  : (stepNumber <= currentStep
                                      ? AppColors.medicalBlue
                                      : AppColors.borderSubtle),
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? AppColors.medicalBlue
                                  : isCompleted
                                      ? AppColors.emeraldSuccess
                                      : AppColors.secondarySurface,
                              border: Border.all(
                                color: isCurrent
                                    ? AppColors.medicalBlue
                                    : isCompleted
                                        ? AppColors.emeraldSuccess
                                        : AppColors.borderSubtle,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                                  : Text(
                                      '$stepNumber',
                                      style: AppStyles.bodySmall.copyWith(
                                        color: isCurrent ? Colors.white : AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: index == steps.length - 1
                                  ? Colors.transparent
                                  : (stepNumber < currentStep
                                      ? AppColors.medicalBlue
                                      : AppColors.borderSubtle),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        stepLabel,
                        style: AppStyles.bodySmall.copyWith(
                          color: isCurrent ? AppColors.medicalBlue : AppColors.textSecondary,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
