import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../providers/medical_records_provider.dart';
import '../widgets/camera_scan_viewfinder.dart';

class DoctorQrScannerScreen extends ConsumerStatefulWidget {
  const DoctorQrScannerScreen({super.key});

  @override
  ConsumerState<DoctorQrScannerScreen> createState() => _DoctorQrScannerScreenState();
}

class _DoctorQrScannerScreenState extends ConsumerState<DoctorQrScannerScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _handleSuccessfulScan(String payload) {
    // Notify provider that doctor scanned the QR
    ref.read(medicalRecordsProvider.notifier).simulateDoctorAccess(
          doctorName: 'Dr. Rajesh Sharma, MD',
          room: 'OPD Consultation Room 4',
        );

    // Show Decrypted Patient Consultation Sheet
    _showDecryptedPatientModal(context);
  }

  void _showManualPinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.dialpad_rounded, color: AppColors.medicalBlue),
            const SizedBox(width: 8),
            Text('Enter Access PIN', style: AppStyles.heading3.copyWith(fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-character access PIN displayed on the patient\'s mobile screen.',
              style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              textCapitalization: TextCapitalization.characters,
              autofocus: true,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2),
              decoration: const InputDecoration(
                hintText: 'e.g. AV-4892',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSuccessfulScan('arogyavani://session/manual-pin');
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.medicalBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Verify PIN'),
          ),
        ],
      ),
    );
  }

  void _showDecryptedPatientModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 18),

            // Patient Decrypted Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.medicalBlueSoft,
                  child: const Text(
                    'H',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.medicalBlue),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('HAMZALI KHAN', style: AppStyles.heading2.copyWith(fontSize: 18)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Token #12',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.medicalBlue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Male, 20 yrs · Registered: +91 9955739705', style: AppStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live Decrypted Clinical Content
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.emeraldBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: AppColors.emeraldSuccess, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Decrypted Health Record · Single-Session Authorized by Patient',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.emeraldSuccess),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chief Complaints:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Wrap(
                      spacing: 8,
                      children: [
                        Chip(label: Text('Fever / Febrile illness')),
                        Chip(label: Text('Generalized body pain (Myalgia)')),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text('HPI Narrative (Voice Intake):', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        'Hamzali Khan, a 20-year-old, presents with Fever / Febrile illness, Generalized body pain (Myalgia). Patient reported high fever with severe myalgia. No known drug allergies reported.',
                        style: AppStyles.bodySmall.copyWith(height: 1.45, color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text('Recent Vitals & Lab Summary:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Hemoglobin (CBC):', style: TextStyle(fontSize: 12)),
                              Text('13.5 g/dL (Normal)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.emeraldSuccess)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Cholesterol:', style: TextStyle(fontSize: 12)),
                              Text('228 mg/dL (Elevated)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.warningText)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Open Full Report CTA
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push(AppRoutes.clinicalReport);
              },
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Open Full Doctor-Ready Clinical Report'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.medicalBlue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark clinical slate for scanner view
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doctor Optical Scanner',
              style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w700),
            ),
            Text(
              'Dr. Rajesh Sharma, MD · Consultation Desk',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11.5),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                'Point Camera at Patient QR Code',
                style: AppStyles.heading2.copyWith(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Scan the consultation pass shown on patient\'s Arogyavani app',
                style: AppStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Camera Viewfinder Component
              CameraScanViewfinder(
                onCodeScanned: _handleSuccessfulScan,
                onManualPinTap: _showManualPinDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
