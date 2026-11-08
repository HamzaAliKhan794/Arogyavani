import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../models/medical_record_model.dart';

class OpdVisitCard extends StatelessWidget {
  final OpdVisit visit;
  final VoidCallback? onViewSoap;
  final VoidCallback? onViewPrescription;
  final VoidCallback? onViewLabs;

  const OpdVisitCard({
    super.key,
    required this.visit,
    this.onViewSoap,
    this.onViewPrescription,
    this.onViewLabs,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(visit.visitDate);
    final isInProgress = visit.status == OpdVisitStatus.inConsultation;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isInProgress ? AppColors.medicalBlue.withValues(alpha: 0.5) : AppColors.borderSubtle,
          width: isInProgress ? 1.5 : 1,
        ),
        boxShadow: AppStyles.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Doctor info & Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isInProgress ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medical_services_outlined,
                  color: isInProgress ? AppColors.medicalBlue : AppColors.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            visit.doctorName,
                            style: AppStyles.heading3.copyWith(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFDBEAFE)),
                          ),
                          child: Text(
                            visit.tokenNumber,
                            style: const TextStyle(
                              color: AppColors.medicalBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${visit.specialty} · ${visit.clinicOrHospital}',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Date & Status Row
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                '$formattedDate · ${visit.visitTime}',
                style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isInProgress ? AppColors.emeraldBg : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isInProgress ? AppColors.emeraldSuccess : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      visit.status.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isInProgress ? AppColors.emeraldSuccess : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Chief Complaints Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: visit.chiefComplaints.map((c) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  c,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Diagnosis Preview
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 15, color: AppColors.medicalBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Diagnosis: ${visit.diagnosis}',
                    style: AppStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons Bar
          Row(
            children: [
              if (visit.soapSummaryAvailable)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewSoap,
                    icon: const Icon(Icons.auto_awesome_rounded, size: 14),
                    label: const Text('SOAP Summary', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              if (visit.soapSummaryAvailable) const SizedBox(width: 8),
              if (visit.prescriptionsCount > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewPrescription,
                    icon: const Icon(Icons.medication_outlined, size: 14),
                    label: Text('Rx (${visit.prescriptionsCount})', style: const TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
