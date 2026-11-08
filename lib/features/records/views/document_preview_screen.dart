import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/medical_record_model.dart';
import '../providers/medical_records_provider.dart';

class DocumentPreviewScreen extends ConsumerStatefulWidget {
  const DocumentPreviewScreen({super.key});

  @override
  ConsumerState<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends ConsumerState<DocumentPreviewScreen> {
  late TextEditingController _titleController;
  late TextEditingController _doctorController;
  late TextEditingController _hospitalController;
  final TextEditingController _customTagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final draft = ref.read(medicalRecordsProvider).uploadDraft;
    _titleController = TextEditingController(text: draft.title);
    _doctorController = TextEditingController(text: draft.doctorOrLab);
    _hospitalController = TextEditingController(text: draft.hospitalOrClinic);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _doctorController.dispose();
    _hospitalController.dispose();
    _customTagController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final notifier = ref.read(medicalRecordsProvider.notifier);
    notifier.setDraftTitle(_titleController.text.trim());
    notifier.setDraftDoctor(_doctorController.text.trim());
    notifier.setDraftHospital(_hospitalController.text.trim());
    notifier.saveDraftToRecords();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document successfully saved to Arogyavani Health Vault!'),
        backgroundColor: AppColors.primaryTeal,
        duration: Duration(seconds: 2),
      ),
    );

    context.go(AppRoutes.medicalRecords);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicalRecordsProvider);
    final draft = state.uploadDraft;
    final notifier = ref.read(medicalRecordsProvider.notifier);
    final dateFormat = DateFormat('dd MMMM yyyy');

    const defaultSuggestedTags = [
      '#BloodTest',
      '#Fever',
      '#Prescription',
      '#XRay',
      '#Discharge',
      '#Cardio',
    ];

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
            Text('Document Preview & Category', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              draft.fileName.isNotEmpty ? draft.fileName : 'New Clinical Document',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Visual Document Preview Frame
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                        boxShadow: AppStyles.cardShadow,
                      ),
                      child: Column(
                        children: [
                          // Frame Header bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                              border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: draft.fileType == 'PDF' ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    draft.fileType,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: draft.fileType == 'PDF' ? const Color(0xFFDC2626) : AppColors.medicalBlue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    draft.fileName,
                                    style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  draft.fileSize,
                                  style: AppStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),

                          // Rendered Mock Document Canvas
                          Container(
                            height: 180,
                            width: double.infinity,
                            color: const Color(0xFFFAFAFA),
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    draft.fileType == 'PDF' ? Icons.description_rounded : Icons.image_rounded,
                                    size: 48,
                                    color: AppColors.medicalBlue.withValues(alpha: 0.8),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'High-Fidelity Document Preview Ready',
                                    style: AppStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Page 1 of 1 · Verified checksum',
                                    style: AppStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Categorisation Section
                    Text('Select Document Category:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: DocumentCategory.values.map((cat) {
                        final isSelected = draft.category == cat;
                        return ChoiceChip(
                          selected: isSelected,
                          label: Text(cat.label),
                          onSelected: (_) => notifier.setDraftCategory(cat),
                          selectedColor: const Color(0xFFEFF6FF),
                          labelStyle: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.medicalBlue : AppColors.textSecondary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                            side: BorderSide(
                              color: isSelected ? AppColors.medicalBlue : AppColors.borderSubtle,
                              width: 1.2,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Metadata Input Form
                    Text('Document Information:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),

                    // Title
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Document Title',
                        hintText: 'e.g. Complete Blood Count Report',
                        prefixIcon: Icon(Icons.title_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Doctor / Diagnostic Center
                    TextField(
                      controller: _doctorController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor or Diagnostic Lab',
                        hintText: 'e.g. Dr. Lal PathLabs or Dr. Sharma',
                        prefixIcon: Icon(Icons.biotech_outlined, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Hospital / Clinic
                    TextField(
                      controller: _hospitalController,
                      decoration: const InputDecoration(
                        labelText: 'Hospital / Clinic / Center',
                        hintText: 'e.g. Apollo Health City or City Clinic',
                        prefixIcon: Icon(Icons.local_hospital_outlined, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date Picker Tile
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: draft.documentDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          notifier.setDraftDate(picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.medicalBlue),
                                const SizedBox(width: 12),
                                Text(
                                  'Document Date: ${dateFormat.format(draft.documentDate)}',
                                  style: AppStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.edit_calendar_rounded, size: 18, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tagging System
                    Text('Health Tags:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: defaultSuggestedTags.map((tag) {
                        final isAdded = draft.tags.contains(tag);
                        return ActionChip(
                          avatar: Icon(
                            isAdded ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                            size: 16,
                            color: isAdded ? Colors.white : AppColors.medicalBlue,
                          ),
                          label: Text(tag),
                          backgroundColor: isAdded ? AppColors.medicalBlue : const Color(0xFFF8FAFC),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isAdded ? Colors.white : AppColors.textPrimary,
                          ),
                          onPressed: () {
                            if (isAdded) {
                              notifier.removeDraftTag(tag);
                            } else {
                              notifier.addDraftTag(tag);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Save Button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: PrimaryButton(
                text: 'Save to Health Records',
                icon: Icons.check_circle_outline_rounded,
                onPressed: _handleSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
