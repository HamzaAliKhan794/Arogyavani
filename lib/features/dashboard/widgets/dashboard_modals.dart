import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/arogyavani_badge.dart';
import '../../../core/widgets/primary_button.dart';

class DashboardModals {
  DashboardModals._();

  /// ABHA Connection Status Modal (Scope 3)
  static void showAbhaDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ABHA Health ID', style: AppStyles.heading2.copyWith(fontSize: 20)),
                ArogyavaniBadge.abhaReady(),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ABHA Number', style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text('91-8842-1920-4491', style: AppStyles.heading3.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  Text('ABHA Address', style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text('hamza@abdm', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: AppColors.emeraldSuccess, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Consented for secure clinical record exchange per consultation.',
                    style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Done',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Doctor QR Modal (Scope 5)
  static void showDoctorQrModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 20),
            Text('Doctor Share QR Code', style: AppStyles.heading2.copyWith(fontSize: 20)),
            const SizedBox(height: 6),
            Text(
              'Show this to the consulting doctor to grant temporary 1-hour access to your clinical history.',
              textAlign: TextAlign.center,
              style: AppStyles.subtitle.copyWith(fontSize: 13.5),
            ),
            const SizedBox(height: 24),
            // Mock QR container
            Container(
              width: 170,
              height: 170,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSubtle, width: 1.5),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.qr_code_2_rounded, size: 108, color: AppColors.primaryTeal),
                    const SizedBox(height: 4),
                    Text(
                      'TOKEN #12 · HAMZA',
                      style: AppStyles.badgeText.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.emeraldBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.emeraldBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: AppColors.emeraldSuccess),
                  const SizedBox(width: 6),
                  Text(
                    'Access valid for: 58 mins (Revocable anytime)',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.emeraldSuccess,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Close QR Code',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// OPD Visits Sheet (Scope 5)
  static void showOpdVisitsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Active OPD Consultation', style: AppStyles.heading2.copyWith(fontSize: 19)),
                ),
                const SizedBox(width: 8),
                ArogyavaniBadge.opdLive(),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tilePeachBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.tilePeachIcon,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '#12',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr. Rajesh Sharma, MD', style: AppStyles.heading3.copyWith(fontSize: 15)),
                        const SizedBox(height: 2),
                        Text('Room 104 · General Medicine', style: AppStyles.bodySmall),
                        const SizedBox(height: 4),
                        Text('Est. Wait Time: ~10 mins (2 patients ahead)',
                            style: AppStyles.bodySmall.copyWith(color: AppColors.tilePeachIcon, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Got It',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Lab Reports Sheet (Scope 5)
  static void showLabReportsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Recent Lab Reports', style: AppStyles.heading2.copyWith(fontSize: 20)),
            const SizedBox(height: 6),
            Text('Uploaded diagnostic tests & blood panels', style: AppStyles.subtitle.copyWith(fontSize: 13.5)),
            const SizedBox(height: 16),
            _ReportListItem(
              title: 'Complete Blood Count (CBC)',
              date: '14 Oct 2026',
              status: 'Normal',
              statusColor: AppColors.emeraldSuccess,
            ),
            const SizedBox(height: 10),
            _ReportListItem(
              title: 'Serum Creatinine & Electrolytes',
              date: '02 Sep 2026',
              status: 'Verified',
              statusColor: AppColors.medicalBlue,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Rx Records Sheet (Scope 5)
  static void showRxRecordsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Prescription Records', style: AppStyles.heading2.copyWith(fontSize: 20)),
            const SizedBox(height: 6),
            Text('Active and past doctor prescriptions', style: AppStyles.subtitle.copyWith(fontSize: 13.5)),
            const SizedBox(height: 16),
            _ReportListItem(
              title: 'Paracetamol 650mg — SOS Fever',
              date: 'Prescribed by Dr. R. Sharma',
              status: 'Active',
              statusColor: AppColors.emeraldSuccess,
            ),
            const SizedBox(height: 10),
            _ReportListItem(
              title: 'Pantoprazole 40mg — Once Daily',
              date: 'Prescribed by Dr. K. Mehta',
              status: 'Completed',
              statusColor: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Generic Service Info Modal (Scope 7)
  static void showServiceDetail(BuildContext context, String serviceName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(serviceName, style: AppStyles.heading2.copyWith(fontSize: 20)),
            const SizedBox(height: 10),
            Text(
              'Arogyavani digital health services enable seamless patient coordination with verified healthcare providers and government health benefits.',
              style: AppStyles.subtitle.copyWith(height: 1.45),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportListItem extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final Color statusColor;

  const _ReportListItem({
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(date, style: AppStyles.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: AppStyles.badgeText.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
