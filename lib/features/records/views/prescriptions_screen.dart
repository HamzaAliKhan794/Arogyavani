import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';
import '../widgets/prescription_card.dart';

class PrescriptionsScreen extends ConsumerWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptions = ref.watch(medicalRecordsProvider).prescriptions;

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
            Text('Prescription Records', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              '${prescriptions.length} Active Digital Prescriptions',
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
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          itemCount: prescriptions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final p = prescriptions[index];
            return PrescriptionCard(
              prescription: p,
              onViewDetails: () => _showRxDetails(context, p),
              onSetReminder: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Daily medicine reminders scheduled for "${p.medications.first.name}"'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showRxDetails(BuildContext context, PrescriptionRecord rx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.70,
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rx.doctorName, style: AppStyles.heading2.copyWith(fontSize: 18)),
                      Text('${rx.specialty} · ${rx.clinicName}', style: AppStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Reg: ${rx.doctorRegistrationNo}',
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.emeraldSuccess),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Diagnosis: ${rx.diagnosis}', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Text('Prescribed Medications:', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: rx.medications.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final m = rx.medications[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(m.name, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                            Text(m.frequency, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.medicalBlue, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Dosage: ${m.dosage} · Duration: ${m.duration}', style: AppStyles.bodySmall.copyWith(fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('Instructions: ${m.instructions}', style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11.5)),
                      ],
                    ),
                  );
                },
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.medicalBlue,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close Prescription'),
            ),
          ],
        ),
      ),
    );
  }
}
