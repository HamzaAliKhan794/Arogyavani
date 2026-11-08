import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';

class MedicalDocumentUploadScreen extends ConsumerStatefulWidget {
  const MedicalDocumentUploadScreen({super.key});

  @override
  ConsumerState<MedicalDocumentUploadScreen> createState() => _MedicalDocumentUploadScreenState();
}

class _MedicalDocumentUploadScreenState extends ConsumerState<MedicalDocumentUploadScreen> {
  bool _isProcessingUpload = false;

  void _handleSelectFile({
    required String name,
    required String type,
    required String size,
    required String defaultTitle,
    required DocumentCategory defaultCategory,
  }) async {
    setState(() => _isProcessingUpload = true);

    ref.read(medicalRecordsProvider.notifier).pickSimulatedFile(
          fileName: name,
          fileType: type,
          fileSize: size,
          defaultTitle: defaultTitle,
          defaultCategory: defaultCategory,
        );

    // Simulate short processing / reading file buffer (600ms)
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _isProcessingUpload = false);
      // Route to Module 6: Document Preview and Categorisation
      context.push(AppRoutes.documentPreview);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text('Upload Medical Document', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Securely store scans, labs & prescriptions',
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
              // Dashed Dropzone Surface
              Container(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.medicalBlue.withValues(alpha: 0.4),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  boxShadow: AppStyles.cardShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEFF6FF),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        size: 32,
                        color: AppColors.medicalBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Drag & Drop or Select Document',
                      style: AppStyles.heading3.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Supported formats: PDF, JPG, PNG, DICOM\nMaximum file size: 25 MB',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isProcessingUpload) ...[
                      const SizedBox(height: 20),
                      const SizedBox(
                        width: 140,
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: Color(0xFFEFF6FF),
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.medicalBlue),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Preparing document preview...', style: AppStyles.bodySmall.copyWith(fontSize: 11)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upload Action Options
              Text('Choose Upload Source:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _UploadSourceTile(
                icon: Icons.description_outlined,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: AppColors.medicalBlue,
                title: 'Browse Files (PDF / Document)',
                subtitle: 'Choose clinical records or lab PDFs from your device',
                onTap: () => _handleSelectFile(
                  name: 'Thyroid_Profile_Report.pdf',
                  type: 'PDF',
                  size: '1.8 MB',
                  defaultTitle: 'Thyroid Function Test (TFT)',
                  defaultCategory: DocumentCategory.labReport,
                ),
              ),
              const SizedBox(height: 10),
              _UploadSourceTile(
                icon: Icons.camera_alt_outlined,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: AppColors.warningText,
                title: 'Scan Document with Camera',
                subtitle: 'Snap a clear photo of physical prescription or bill',
                onTap: () => _handleSelectFile(
                  name: 'Camera_Prescription_Scan_01.jpg',
                  type: 'JPG',
                  size: '2.4 MB',
                  defaultTitle: 'Prescription Slip - Apollo Clinic',
                  defaultCategory: DocumentCategory.prescription,
                ),
              ),
              const SizedBox(height: 10),
              _UploadSourceTile(
                icon: Icons.photo_library_outlined,
                iconBg: const Color(0xFFECFDF5),
                iconColor: AppColors.emeraldSuccess,
                title: 'Select from Photo Gallery',
                subtitle: 'Upload existing scan or medical photograph',
                onTap: () => _handleSelectFile(
                  name: 'Knee_Joint_MRI_Scan.png',
                  type: 'PNG',
                  size: '3.1 MB',
                  defaultTitle: 'Knee Joint Diagnostic Scan',
                  defaultCategory: DocumentCategory.scanOrXray,
                ),
              ),
              const SizedBox(height: 24),

              // Development Preloaded Samples
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded, size: 18, color: AppColors.medicalBlue),
                        const SizedBox(width: 6),
                        Text(
                          'Test with Sample Clinical Documents',
                          style: AppStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.medicalBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _QuickSampleButton(
                      label: 'Sample Blood Lab Report (PDF)',
                      onTap: () => _handleSelectFile(
                        name: 'Serum_Electrolytes_Report.pdf',
                        type: 'PDF',
                        size: '1.2 MB',
                        defaultTitle: 'Serum Electrolytes & Renal Panel',
                        defaultCategory: DocumentCategory.labReport,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _QuickSampleButton(
                      label: 'Sample Orthopedic X-Ray (JPG)',
                      onTap: () => _handleSelectFile(
                        name: 'Lumbar_Spine_XRay.jpg',
                        type: 'JPG',
                        size: '4.1 MB',
                        defaultTitle: 'Lumbar Spine AP/Lateral X-Ray',
                        defaultCategory: DocumentCategory.scanOrXray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _QuickSampleButton(
                      label: 'Sample Hospital Discharge Summary (PDF)',
                      onTap: () => _handleSelectFile(
                        name: 'Discharge_Summary_MaxHealthcare.pdf',
                        type: 'PDF',
                        size: '2.8 MB',
                        defaultTitle: 'Inpatient Discharge Summary',
                        defaultCategory: DocumentCategory.dischargeSummary,
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

class _UploadSourceTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UploadSourceTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle, width: 1.2),
          boxShadow: AppStyles.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.heading3.copyWith(fontSize: 14.5)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppStyles.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _QuickSampleButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickSampleButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.touch_app_rounded, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.medicalBlue,
        side: const BorderSide(color: AppColors.borderSubtle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
