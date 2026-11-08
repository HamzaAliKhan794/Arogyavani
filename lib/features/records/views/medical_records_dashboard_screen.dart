import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/security_lock_footer.dart';
import '../providers/medical_records_provider.dart';
import '../widgets/document_item_card.dart';
import '../widgets/lab_report_card.dart';
import '../widgets/opd_visit_card.dart';
import '../widgets/prescription_card.dart';
import '../widgets/record_category_tabs.dart';

class MedicalRecordsDashboardScreen extends ConsumerWidget {
  const MedicalRecordsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(medicalRecordsProvider);
    final notifier = ref.read(medicalRecordsProvider.notifier);

    // Calculate category counts
    final Map<String, int> counts = <String, int>{
      'All': state.opdVisits.length + state.labReports.length + state.prescriptions.length + state.uploadedDocuments.length,
      'OPD Visits': state.opdVisits.length,
      'Lab Reports': state.labReports.length,
      'Prescriptions': state.prescriptions.length,
      'Uploaded Docs': state.uploadedDocuments.length,
    };

    // Filter items according to search query and selected category
    final query = state.searchQuery.toLowerCase();

    final filteredVisits = state.opdVisits.where((v) {
      if (query.isEmpty) return true;
      return v.doctorName.toLowerCase().contains(query) ||
          v.diagnosis.toLowerCase().contains(query) ||
          v.tokenNumber.toLowerCase().contains(query);
    }).toList();

    final filteredLabs = state.labReports.where((l) {
      if (query.isEmpty) return true;
      return l.testName.toLowerCase().contains(query) ||
          l.labName.toLowerCase().contains(query) ||
          l.testCategory.toLowerCase().contains(query);
    }).toList();

    final filteredPrescriptions = state.prescriptions.where((p) {
      if (query.isEmpty) return true;
      return p.doctorName.toLowerCase().contains(query) ||
          p.diagnosis.toLowerCase().contains(query) ||
          p.clinicName.toLowerCase().contains(query);
    }).toList();

    final filteredDocuments = state.uploadedDocuments.where((d) {
      if (query.isEmpty) return true;
      return d.title.toLowerCase().contains(query) ||
          d.doctorOrLab.toLowerCase().contains(query) ||
          d.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.patientDashboard),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical Records', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Arogyavani Health Vault · ${counts['All']} Records',
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
            tooltip: 'Share with Doctor',
            icon: const Icon(Icons.qr_code_2_rounded, color: AppColors.medicalBlue),
            onPressed: () => context.push(AppRoutes.doctorQr),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                onChanged: notifier.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search visits, tests, doctors, medications...',
                  hintStyle: AppStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () => notifier.setSearchQuery(''),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  fillColor: Colors.white,
                ),
              ),
            ),

            // Quick Action Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.push(AppRoutes.medicalDocumentUpload),
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: const Text('Upload Document'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(AppRoutes.doctorQr),
                      icon: const Icon(Icons.qr_code_rounded, size: 18),
                      label: const Text('Doctor QR'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.medicalBlue,
                        side: const BorderSide(color: AppColors.medicalBlue, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Horizontal Category Tabs
            RecordCategoryTabs(
              selectedCategory: state.selectedCategory,
              onSelect: notifier.setSelectedCategory,
              counts: counts,
            ),
            const SizedBox(height: 12),

            // Records List View
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  // Section: OPD Visits
                  if (state.selectedCategory == 'All' || state.selectedCategory == 'OPD Visits') ...[
                    if (filteredVisits.isNotEmpty) ...[
                      _SectionHeader(
                        title: 'OPD Consultations',
                        count: filteredVisits.length,
                        onViewAll: () => context.push(AppRoutes.opdVisitsHistory),
                      ),
                      const SizedBox(height: 8),
                      ...filteredVisits.map((v) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: OpdVisitCard(
                              visit: v,
                              onViewSoap: () => context.push(AppRoutes.clinicalReport),
                              onViewPrescription: () => notifier.setSelectedCategory('Prescriptions'),
                            ),
                          )),
                      const SizedBox(height: 8),
                    ],
                  ],

                  // Section: Lab Reports
                  if (state.selectedCategory == 'All' || state.selectedCategory == 'Lab Reports') ...[
                    if (filteredLabs.isNotEmpty) ...[
                      _SectionHeader(
                        title: 'Lab & Diagnostic Reports',
                        count: filteredLabs.length,
                        onViewAll: () => context.push(AppRoutes.labReports),
                      ),
                      const SizedBox(height: 8),
                      ...filteredLabs.map((l) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: LabReportCard(
                              report: l,
                              onViewDetails: () => _showLabDetailsModal(context, l),
                              onDownload: () => _showDownloadToast(context, l.testName),
                            ),
                          )),
                      const SizedBox(height: 8),
                    ],
                  ],

                  // Section: Prescriptions
                  if (state.selectedCategory == 'All' || state.selectedCategory == 'Prescriptions') ...[
                    if (filteredPrescriptions.isNotEmpty) ...[
                      _SectionHeader(
                        title: 'Digital Prescriptions',
                        count: filteredPrescriptions.length,
                        onViewAll: () => context.push(AppRoutes.prescriptionRecords),
                      ),
                      const SizedBox(height: 8),
                      ...filteredPrescriptions.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PrescriptionCard(
                              prescription: p,
                              onViewDetails: () => _showRxSlipModal(context, p),
                              onSetReminder: () => _showReminderToast(context, p.medications.first.name),
                            ),
                          )),
                      const SizedBox(height: 8),
                    ],
                  ],

                  // Section: Uploaded Documents
                  if (state.selectedCategory == 'All' || state.selectedCategory == 'Uploaded Docs') ...[
                    if (filteredDocuments.isNotEmpty) ...[
                      _SectionHeader(
                        title: 'Uploaded Documents & Scans',
                        count: filteredDocuments.length,
                        onViewAll: null,
                      ),
                      const SizedBox(height: 8),
                      ...filteredDocuments.map((d) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DocumentItemCard(
                              document: d,
                              onPreview: () => _showDocumentPreviewModal(context, d),
                              onDownload: () => _showDownloadToast(context, d.title),
                            ),
                          )),
                    ],
                  ],

                  const SizedBox(height: 16),
                  const SecurityLockFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLabDetailsModal(BuildContext context, dynamic lab) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
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
                decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 18),
            Text(lab.testName, style: AppStyles.heading2.copyWith(fontSize: 18)),
            Text('${lab.testCategory} · ${lab.labName}', style: AppStyles.bodySmall),
            const SizedBox(height: 16),
            Text('Clinical Interpretation:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(lab.resultSummary, style: AppStyles.bodySmall.copyWith(height: 1.4)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Close'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.medicalBlue,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRxSlipModal(BuildContext context, dynamic rx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
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
                decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 18),
            Text('Prescription Details', style: AppStyles.heading2.copyWith(fontSize: 18)),
            Text('${rx.doctorName} · Reg: ${rx.doctorRegistrationNo}', style: AppStyles.bodySmall),
            const SizedBox(height: 16),
            Text('Diagnosis: ${rx.diagnosis}', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Text('Medications (${rx.medications.length}):', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            ...rx.medications.map((m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• ${m.name} - ${m.dosage} (${m.frequency}) for ${m.duration}', style: AppStyles.bodySmall),
                )),
            const SizedBox(height: 20),
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

  void _showDocumentPreviewModal(BuildContext context, dynamic doc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
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
                decoration: BoxDecoration(color: AppColors.borderSubtle, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 18),
            Text(doc.title, style: AppStyles.heading2.copyWith(fontSize: 18)),
            Text('${doc.category.label} · ${doc.fileSize} · ${doc.fileType}', style: AppStyles.bodySmall),
            const SizedBox(height: 16),
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      doc.fileType == 'PDF' ? Icons.picture_as_pdf_rounded : Icons.image_outlined,
                      size: 40,
                      color: AppColors.medicalBlue,
                    ),
                    const SizedBox(height: 8),
                    Text('Document Preview Rendered', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                    Text('Notes: ${doc.notes ?? "No extra notes"}', style: AppStyles.bodySmall.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.medicalBlue,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close Preview'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadToast(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading "$title" for offline viewing...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showReminderToast(BuildContext context, String medName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pill reminder set for $medName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback? onViewAll;

  const _SectionHeader({
    required this.title,
    required this.count,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppStyles.heading3.copyWith(fontSize: 14.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.medicalBlue),
              ),
            ),
          ],
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
            child: const Text('View All', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
