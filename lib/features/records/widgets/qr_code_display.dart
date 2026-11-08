import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../models/medical_record_model.dart';

class QrCodeDisplay extends StatelessWidget {
  final DoctorShareSession session;
  final VoidCallback? onConfigureTap;
  final VoidCallback? onRevokeTap;

  const QrCodeDisplay({
    super.key,
    required this.session,
    this.onConfigureTap,
    this.onRevokeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRevoked = session.status == ShareSessionStatus.revoked;
    final isExpired = session.isExpired;
    final isAccessed = session.status == ShareSessionStatus.accessed;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderSubtle, width: 1.2),
        boxShadow: AppStyles.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        children: [
          // Session Status Pill & Countdown Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isRevoked || isExpired
                      ? const Color(0xFFFEE2E2)
                      : isAccessed
                          ? const Color(0xFFEFF6FF)
                          : AppColors.emeraldBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isRevoked || isExpired
                        ? const Color(0xFFFECACA)
                        : isAccessed
                            ? const Color(0xFFDBEAFE)
                            : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRevoked || isExpired
                            ? AppColors.coralError
                            : isAccessed
                                ? AppColors.medicalBlue
                                : AppColors.emeraldSuccess,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isRevoked
                          ? 'Session Revoked'
                          : isExpired
                              ? 'Session Expired'
                              : isAccessed
                                  ? 'Doctor Reviewing'
                                  : 'Active · Ready to Scan',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isRevoked || isExpired
                            ? AppColors.coralError
                            : isAccessed
                                ? AppColors.medicalBlue
                                : AppColors.emeraldSuccess,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      isRevoked || isExpired ? '00:00' : session.formattedRemainingTime,
                      style: AppStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isRevoked || isExpired ? AppColors.coralError : AppColors.textPrimary,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // High-Contrast QR Code Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isRevoked && !isExpired)
                  QrImageView(
                    data: session.qrPayload,
                    version: QrVersions.auto,
                    size: 200.0,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF0F172A),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF0F172A),
                    ),
                  )
                else
                  Container(
                    width: 200,
                    height: 200,
                    color: const Color(0xFFF8FAFC),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isRevoked ? Icons.block_rounded : Icons.timer_off_outlined,
                          size: 44,
                          color: AppColors.coralError,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isRevoked ? 'QR Inactive' : 'QR Expired',
                          style: AppStyles.heading3.copyWith(
                            fontSize: 14,
                            color: AppColors.coralError,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Generate a new code below',
                          style: AppStyles.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),

                // Center Arogyavani Icon Mark
                if (!isRevoked && !isExpired)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.medicalBlue, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.add_rounded, color: AppColors.medicalBlue, size: 24),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Patient Name & Token Identifier
          Text(
            session.patientName,
            style: AppStyles.heading2.copyWith(fontSize: 17, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            '${session.tokenNumber} · Consultation Pass',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.medicalBlue,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),

          // Backup 6-Digit PIN Code for Manual Entry
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDBEAFE), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pin_outlined, size: 16, color: AppColors.medicalBlue),
                const SizedBox(width: 8),
                Text(
                  'Doctor Access PIN: ',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                  ),
                ),
                Text(
                  session.accessPin,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.medicalBlue,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: session.accessPin));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PIN copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(Icons.copy_rounded, size: 16, color: AppColors.medicalBlue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Clinical Permission Pills Summary
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              if (session.shareSoapSummary) _PermissionPill(label: 'SOAP Intake'),
              if (session.shareChiefComplaints) _PermissionPill(label: 'Complaints'),
              if (session.shareRecentVisits) _PermissionPill(label: 'Visits'),
              if (session.shareLabReports) _PermissionPill(label: 'Labs'),
              if (session.sharePrescriptions) _PermissionPill(label: 'Rx'),
              if (session.shareUploadedDocuments) _PermissionPill(label: 'Uploaded Docs'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PermissionPill extends StatelessWidget {
  final String label;
  const _PermissionPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 11, color: AppColors.emeraldSuccess),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
