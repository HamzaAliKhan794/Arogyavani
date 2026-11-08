import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';

class ShareAccessStatusScreen extends ConsumerWidget {
  const ShareAccessStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicalRecordsProvider);
    final session = state.activeShareSession;
    final notifier = ref.read(medicalRecordsProvider.notifier);
    final timeFormat = DateFormat('hh:mm a');

    final isRevoked = session.status == ShareSessionStatus.revoked;
    final isExpired = session.isExpired;
    final isAccessed = session.status == ShareSessionStatus.accessed;

    final progress = session.totalDuration.inSeconds > 0
        ? (session.remainingTime.inSeconds / session.totalDuration.inSeconds).clamp(0.0, 1.0)
        : 0.0;

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
            Text('Access Status & Audit Log', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Real-Time Physician Consultation Tracker',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Live Session Overview Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isRevoked || isExpired
                        ? const Color(0xFFFECACA)
                        : isAccessed
                            ? AppColors.medicalBlue
                            : AppColors.borderSubtle,
                    width: isAccessed ? 1.5 : 1.2,
                  ),
                  boxShadow: AppStyles.cardShadow,
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Session Status', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isRevoked || isExpired
                                ? const Color(0xFFFEE2E2)
                                : isAccessed
                                    ? const Color(0xFFEFF6FF)
                                    : AppColors.emeraldBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isRevoked
                                ? 'Revoked'
                                : isExpired
                                    ? 'Expired'
                                    : isAccessed
                                        ? 'Active · In Consultation'
                                        : 'Active · Waiting for Scan',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: isRevoked || isExpired
                                  ? AppColors.coralError
                                  : isAccessed
                                      ? AppColors.medicalBlue
                                      : AppColors.emeraldSuccess,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Countdown Remaining
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time Remaining:',
                          style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          isRevoked || isExpired ? '00:00' : session.formattedRemainingTime,
                          style: AppStyles.heading2.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: isRevoked || isExpired ? AppColors.coralError : AppColors.medicalBlue,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: isRevoked || isExpired ? 0.0 : progress,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isRevoked || isExpired
                              ? AppColors.coralError
                              : isAccessed
                                  ? AppColors.medicalBlue
                                  : AppColors.emeraldSuccess,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Session Metadata Row
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PIN: ${session.accessPin}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text(session.tokenNumber, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.medicalBlue, fontSize: 13)),
                          Text(session.sessionId, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons (Extend / Revoke)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              notifier.extendSessionTime(const Duration(minutes: 15));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Extended access session by +15 minutes'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_alarm_rounded, size: 16),
                            label: const Text('+15 Mins'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.medicalBlue,
                              side: const BorderSide(color: AppColors.medicalBlue),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              notifier.revokeSession();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Doctor access revoked immediately.'),
                                  backgroundColor: AppColors.coralError,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.block_rounded, size: 16, color: AppColors.coralError),
                            label: const Text('Revoke Now', style: TextStyle(color: AppColors.coralError)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFECACA)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Simulation trigger for testing
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded, size: 18, color: AppColors.medicalBlue),
                        const SizedBox(width: 6),
                        Text(
                          'Test Doctor Scan Simulation',
                          style: AppStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.medicalBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Simulate what happens when Dr. Sharma scans the QR code at his consultation terminal.',
                      style: AppStyles.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          notifier.simulateDoctorAccess(
                            doctorName: 'Dr. Rajesh Sharma, MD',
                            room: 'OPD Consultation Room 4',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dr. Rajesh Sharma successfully scanned your QR code!'),
                              backgroundColor: AppColors.primaryTeal,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                        label: const Text('Simulate Doctor Scan Now'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.medicalBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Real-Time Audit Log Timeline
              Text('Access Audit Trail:', style: AppStyles.heading3.copyWith(fontSize: 15)),
              const SizedBox(height: 12),
              if (session.accessLogs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Center(
                    child: Text(
                      'No doctor access events logged yet.\nShow your QR code to the doctor to begin.',
                      textAlign: TextAlign.center,
                      style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...session.accessLogs.map((log) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                      boxShadow: AppStyles.cardShadow,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.medicalBlue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      log.doctorName,
                                      style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Text(
                                    timeFormat.format(log.accessedAt),
                                    style: AppStyles.bodySmall.copyWith(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                log.departmentOrRoom,
                                style: AppStyles.bodySmall.copyWith(color: AppColors.medicalBlue, fontSize: 11.5, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                log.action,
                                style: AppStyles.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
