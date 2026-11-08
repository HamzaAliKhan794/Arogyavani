import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/dev_mode_banner.dart';
import '../models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';
import '../widgets/qr_code_display.dart';

class DoctorQrScreen extends ConsumerWidget {
  const DoctorQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicalRecordsProvider);
    final session = state.activeShareSession;
    final notifier = ref.read(medicalRecordsProvider.notifier);
    final isRevoked = session.status == ShareSessionStatus.revoked;
    final isExpired = session.isExpired;

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
            Text('Doctor Access Pass', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Show QR at OPD Consultation Desk',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Configure Permissions',
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push(AppRoutes.shareConfiguration),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DevModeBanner(
                message: 'Development Simulation: QR payload and 6-digit access PIN (AV-4892) are locally simulated for frontend evaluation. Production deployment requires ABDM HIU/HIP gateway digital signatures.',
              ),
              const SizedBox(height: 14),

              // Production QR Display Widget
              QrCodeDisplay(
                session: session,
                onConfigureTap: () => context.push(AppRoutes.shareConfiguration),
                onRevokeTap: () => notifier.revokeSession(),
              ),
              const SizedBox(height: 20),

              // Action Options Grid
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.shareConfiguration),
                      icon: const Icon(Icons.tune_rounded, size: 16),
                      label: const Text('Customize Data', style: TextStyle(fontSize: 12.5)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.medicalBlue,
                        side: const BorderSide(color: AppColors.borderSubtle, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.shareAccessStatus),
                      icon: const Icon(Icons.history_rounded, size: 16),
                      label: const Text('Access Logs', style: TextStyle(fontSize: 12.5)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.borderSubtle, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Revoke or Re-generate Primary Action
              if (isRevoked || isExpired)
                FilledButton.icon(
                  onPressed: () {
                    notifier.resetShareSession();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('New 15-minute secure QR pass generated'),
                        backgroundColor: AppColors.primaryTeal,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Generate New QR Pass'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.medicalBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    notifier.revokeSession();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Doctor access pass terminated immediately.'),
                        backgroundColor: AppColors.coralError,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.block_rounded, size: 16, color: AppColors.coralError),
                  label: const Text(
                    'Revoke Doctor Access Now',
                    style: TextStyle(color: AppColors.coralError, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFECACA), width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              const SizedBox(height: 20),

              // Trust & Security Notice Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lock_clock_outlined, size: 18, color: AppColors.primaryTeal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time-Limited Ephemeral Authorization',
                            style: AppStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'This pass grants single-session read access to your authorized clinical health records. No data is stored outside the consultation session.',
                            style: AppStyles.bodySmall.copyWith(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
