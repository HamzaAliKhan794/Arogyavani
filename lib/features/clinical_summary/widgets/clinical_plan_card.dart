import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class ClinicalPlanCard extends StatelessWidget {
  final String provisionalAssessment;
  final List<String> recommendedActions;

  const ClinicalPlanCard({
    super.key,
    required this.provisionalAssessment,
    required this.recommendedActions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle, width: 1.2),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.emeraldBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.emeraldBorder, width: 1),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  size: 18,
                  color: AppColors.emeraldSuccess,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'A & P - Clinical Plan & Recommendations',
                  style: AppStyles.heading3.copyWith(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 14),

          // Provisional Assessment
          Text(
            'Provisional Assessment:',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            provisionalAssessment,
            style: AppStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Recommended Clinical Actions
          Text(
            'Recommended Clinical Actions:',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          ...recommendedActions.map((action) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 10),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.medicalBlue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        action,
                        style: AppStyles.bodyRegular.copyWith(
                          fontSize: 13.5,
                          height: 1.4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
