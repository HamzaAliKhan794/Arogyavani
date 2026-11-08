import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/profile_provider.dart';

class DoctorConsultationPreferencesScreen extends ConsumerStatefulWidget {
  const DoctorConsultationPreferencesScreen({super.key});

  @override
  ConsumerState<DoctorConsultationPreferencesScreen> createState() => _DoctorConsultationPreferencesScreenState();
}

class _DoctorConsultationPreferencesScreenState extends ConsumerState<DoctorConsultationPreferencesScreen> {
  late int _slotMinutes;
  late bool _autoAdvance;
  late bool _autoExpandSoap;
  late bool _playTranscript;
  late bool _notifyEmergency;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(profileProvider).doctorPreferences;
    _slotMinutes = prefs.consultationSlotMinutes;
    _autoAdvance = prefs.autoAdvanceQueue;
    _autoExpandSoap = prefs.autoExpandSoapSummary;
    _playTranscript = prefs.playVoiceTranscript;
    _notifyEmergency = prefs.notifyEmergencyIntake;
  }

  void _handleSave() {
    ref.read(profileProvider.notifier).updateDoctorPreferences(
          consultationSlotMinutes: _slotMinutes,
          autoAdvanceQueue: _autoAdvance,
          autoExpandSoapSummary: _autoExpandSoap,
          playVoiceTranscript: _playTranscript,
          notifyEmergencyIntake: _notifyEmergency,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Doctor consultation terminal preferences saved successfully!'),
        backgroundColor: AppColors.primaryTeal,
        duration: Duration(seconds: 2),
      ),
    );

    if (GoRouter.maybeOf(context) != null) {
      context.pop();
    } else {
      Navigator.of(context).maybePop();
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
            Text('Consultation Preferences', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Workflow, Pacing & SOAP Note Display',
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                children: [
                  // Consultation Slot Pacing
                  Text('Consultation Slot Pacing', style: AppStyles.heading3.copyWith(fontSize: 15)),
                  const SizedBox(height: 6),
                  Text('Sets the estimated consultation timer for patient queue turn forecasts.', style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                      boxShadow: AppStyles.cardShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: RadioGroup<int>(
                        groupValue: _slotMinutes,
                        onChanged: (val) {
                          if (val != null) setState(() => _slotMinutes = val);
                        },
                        child: Column(
                          children: [10, 15, 20].map((mins) {
                            return RadioListTile<int>(
                              value: mins,
                              title: Text('$mins Minutes Per Patient', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                              subtitle: Text(
                                mins == 15 ? 'Standard OPD consultation baseline' : (mins == 10 ? 'Express consultation pace' : 'Detailed multi-system evaluation'),
                                style: AppStyles.bodySmall.copyWith(fontSize: 11.5),
                              ),
                              activeColor: AppColors.medicalBlue,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Clinical AI SOAP Display
                  Text('Clinical AI SOAP Display', style: AppStyles.heading3.copyWith(fontSize: 15)),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                      boxShadow: AppStyles.cardShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Auto-Expand SOAP Summary', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                            subtitle: const Text('Open chief complaints & HPI immediately upon scanning patient QR code', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                            value: _autoExpandSoap,
                            activeTrackColor: AppColors.medicalBlue,
                            onChanged: (val) => setState(() => _autoExpandSoap = val),
                          ),
                          const Divider(height: 1, color: AppColors.borderSubtle),
                          SwitchListTile(
                            title: const Text('Enable Audio Transcript Playback', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                            subtitle: const Text('Permit listening to the patient\'s verbatim spoken voice intake clip', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                            value: _playTranscript,
                            activeTrackColor: AppColors.medicalBlue,
                            onChanged: (val) => setState(() => _playTranscript = val),
                          ),
                          const Divider(height: 1, color: AppColors.borderSubtle),
                          SwitchListTile(
                            title: const Text('Emergency Triaging Priority', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                            subtitle: const Text('Highlight red flags (chest pain, SpO2 drop, severe fever) at top of queue', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                            value: _notifyEmergency,
                            activeTrackColor: AppColors.medicalBlue,
                            onChanged: (val) => setState(() => _notifyEmergency = val),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Save CTA
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
                text: 'Save Consultation Preferences',
                icon: Icons.check_rounded,
                onPressed: _handleSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
