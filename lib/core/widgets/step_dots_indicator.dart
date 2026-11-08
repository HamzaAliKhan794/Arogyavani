import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StepDotsIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 0-indexed

  const StepDotsIndicator({
    super.key,
    this.totalSteps = 3,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? AppColors.medicalBlue : AppColors.borderSubtle,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
