import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';
import '../widgets/opd_visit_card.dart';

class OpdVisitsScreen extends ConsumerStatefulWidget {
  const OpdVisitsScreen({super.key});

  @override
  ConsumerState<OpdVisitsScreen> createState() => _OpdVisitsScreenState();
}

class _OpdVisitsScreenState extends ConsumerState<OpdVisitsScreen> {
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final visits = ref.watch(medicalRecordsProvider).opdVisits;

    final filtered = visits.where((v) {
      if (_statusFilter == 'Ongoing') return v.status == OpdVisitStatus.inConsultation;
      if (_statusFilter == 'Completed') return v.status == OpdVisitStatus.completed;
      return true;
    }).toList();

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
            Text('OPD Visits History', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              '${visits.length} Recorded Hospital Consultations',
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
        child: Column(
          children: [
            // Filter Pills Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: ['All', 'Ongoing', 'Completed'].map((filter) {
                  final isSelected = _statusFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(filter),
                      onSelected: (_) => setState(() => _statusFilter = filter),
                      selectedColor: const Color(0xFFEFF6FF),
                      checkmarkColor: AppColors.medicalBlue,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.medicalBlue : AppColors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                        side: BorderSide(
                          color: isSelected ? AppColors.medicalBlue : AppColors.borderSubtle,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Visits List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No visits found for filter "$_statusFilter"',
                        style: AppStyles.bodySmall,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final v = filtered[index];
                        return OpdVisitCard(
                          visit: v,
                          onViewSoap: () => context.push(AppRoutes.clinicalReport),
                          onViewPrescription: () {
                            context.push(AppRoutes.prescriptionRecords);
                          },
                          onViewLabs: () {
                            context.push(AppRoutes.labReports);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
