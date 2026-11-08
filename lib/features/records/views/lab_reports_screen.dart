import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';
import '../widgets/lab_report_card.dart';

class LabReportsScreen extends ConsumerStatefulWidget {
  const LabReportsScreen({super.key});

  @override
  ConsumerState<LabReportsScreen> createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends ConsumerState<LabReportsScreen> {
  String _categoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final labs = ref.watch(medicalRecordsProvider).labReports;

    final categories = ['All', 'Hematology', 'Biochemistry', 'Radiology', 'Diabetes Care'];

    final filtered = labs.where((l) {
      if (_categoryFilter == 'All') return true;
      return l.testCategory.toLowerCase() == _categoryFilter.toLowerCase();
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
            Text('Lab & Diagnostic Reports', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              '${labs.length} Verified Diagnostic Results',
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
            // Category Filter Pills
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = _categoryFilter == cat;
                  return FilterChip(
                    selected: isSelected,
                    label: Text(cat),
                    onSelected: (_) => setState(() => _categoryFilter = cat),
                    selectedColor: const Color(0xFFEFF6FF),
                    checkmarkColor: AppColors.medicalBlue,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.medicalBlue : AppColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                      side: BorderSide(
                        color: isSelected ? AppColors.medicalBlue : AppColors.borderSubtle,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Lab Reports List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No lab reports in category "$_categoryFilter"',
                        style: AppStyles.bodySmall,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final l = filtered[index];
                        return LabReportCard(
                          report: l,
                          onViewDetails: () => _showFullParametersModal(context, l),
                          onDownload: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Downloading "${l.testName}" (PDF)...'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
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

  void _showFullParametersModal(BuildContext context, LabReport lab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
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
            Text(lab.testName, style: AppStyles.heading2.copyWith(fontSize: 18)),
            Text('${lab.testCategory} · ${lab.labName}', style: AppStyles.bodySmall),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                'Clinical Summary: ${lab.resultSummary}',
                style: AppStyles.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.4),
              ),
            ),
            const SizedBox(height: 16),
            Text('Complete Parameter Table:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: lab.parameters.length,
                separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.borderSubtle),
                itemBuilder: (context, index) {
                  final p = lab.parameters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                              Text('Ref Range: ${p.referenceRange}', style: AppStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${p.value} ${p.unit}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: p.isAbnormal ? AppColors.coralError : AppColors.textPrimary,
                              ),
                            ),
                            if (p.isAbnormal) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'HIGH',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.coralError),
                                ),
                              ),
                            ],
                          ],
                        ),
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
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
