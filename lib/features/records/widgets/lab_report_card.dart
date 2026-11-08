import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../models/medical_record_model.dart';

class LabReportCard extends StatelessWidget {
  final LabReport report;
  final VoidCallback? onViewDetails;
  final VoidCallback? onDownload;

  const LabReportCard({
    super.key,
    required this.report,
    this.onViewDetails,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(report.testDate);
    final isAttention = report.status == LabReportStatus.attentionNeeded;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isAttention ? AppColors.warningBg : AppColors.borderSubtle,
          width: isAttention ? 1.4 : 1,
        ),
        boxShadow: AppStyles.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Test icon, title & status badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isAttention ? const Color(0xFFFEF3C7) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.biotech_outlined,
                  color: isAttention ? AppColors.warningText : AppColors.medicalBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.testName,
                      style: AppStyles.heading3.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.testCategory} · ${report.labName}',
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAttention ? const Color(0xFFFEF3C7) : AppColors.emeraldBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isAttention ? const Color(0xFFFDE68A) : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Text(
                  report.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isAttention ? AppColors.warningText : AppColors.emeraldSuccess,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Date & Referred Doctor
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                formattedDate,
                style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
              ),
              if (report.doctorReferred != null) ...[
                const SizedBox(width: 12),
                Icon(Icons.person_outline, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Ref: ${report.doctorReferred}',
                    style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Key Parameters Table Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: report.parameters.take(3).map((param) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          param.name,
                          style: AppStyles.bodySmall.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${param.value} ${param.unit}',
                            style: AppStyles.bodySmall.copyWith(
                              fontSize: 12,
                              fontWeight: param.isAbnormal ? FontWeight.w700 : FontWeight.w600,
                              color: param.isAbnormal ? AppColors.coralError : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${param.referenceRange})',
                            style: AppStyles.bodySmall.copyWith(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          if (param.isAbnormal) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_upward_rounded, size: 12, color: AppColors.coralError),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 14),
                  label: const Text('View Parameters', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download_rounded, size: 14),
                label: const Text('PDF', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
