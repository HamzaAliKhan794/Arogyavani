import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/arogyavani_badge.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/voice_intake_provider.dart';
import '../widgets/audio_waveform_visualizer.dart';
import '../widgets/mic_record_button.dart';

class ClinicalVoiceIntakeSheet extends ConsumerWidget {
  const ClinicalVoiceIntakeSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (context) => const ClinicalVoiceIntakeSheet(),
    );
  }

  void _handleSubmitIntake(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    // Route to Phase 5's AI Medical Scribe Pipeline
    context.push(AppRoutes.aiScribe);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intakeState = ref.watch(voiceIntakeProvider);
    final notifier = ref.read(voiceIntakeProvider.notifier);
    final status = intakeState.status;

    double playbackProgress = 0.0;
    if (intakeState.elapsedDuration.inMilliseconds > 0) {
      playbackProgress = (intakeState.playbackPosition.inMilliseconds /
              intakeState.elapsedDuration.inMilliseconds)
          .clamp(0.0, 1.0);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Top Actions Row: Re-record (left) & SOAP AI (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (status.isCaptured || status.isPlaying || status.isRecording)
                  InkWell(
                    onTap: () => notifier.reRecord(),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.secondarySurface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.borderSubtle, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.refresh_rounded, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'Re-record',
                            style: AppStyles.badgeText.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 40),
                ArogyavaniBadge.soapAi(),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Heading
            Text(
              'Clinical Voice Intake',
              style: AppStyles.heading2.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // 3. Subtitle (Hindi, English, Regional)
            Text(
              'Speak naturally in Hindi, English, or Regional',
              style: AppStyles.subtitle.copyWith(
                fontSize: 13.5,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),

            // 4. Audio Waveform Visualizer
            AudioWaveformVisualizer(
              status: status,
              amplitudes: intakeState.amplitudes,
              playbackProgress: playbackProgress,
            ),
            const SizedBox(height: 18),

            // 5. Recording Timer
            Text(
              intakeState.formattedTimer,
              style: AppStyles.heading1.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: status.isRecording ? AppColors.medicalBlue : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // 6. Dynamic Status Instruction Caption
            Text(
              status.isRecording
                  ? 'Listening... Speak symptoms, pain levels & duration'
                  : status.isCaptured
                      ? 'Recording captured. Preview or submit.'
                      : status.isPlaying
                          ? 'Playing back audio recording...'
                          : status.isError
                              ? 'Recording interrupted'
                              : 'Tap microphone below to start speaking',
              style: AppStyles.bodySmall.copyWith(
                color: status.isRecording
                    ? AppColors.medicalBlue
                    : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: status.isRecording ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 7. Coral Error Banner (Image 8 Error State)
            if (status.isError) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.coralBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.coralBorder, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.coralError),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        intakeState.errorMessage ?? 'Could not start recording. Please try again.',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.coralError,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 8. Microphone Button or Playback/Submit Controls
            if (status.isCaptured || status.isPlaying) ...[
              // Audio Playback Preview Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => notifier.togglePlayback(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.medicalBlue,
                      side: const BorderSide(color: AppColors.borderSubtle),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    icon: Icon(
                      status.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 20,
                    ),
                    label: Text(status.isPlaying ? 'Pause Preview' : 'Play Recording'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Submit CTA Button
              PrimaryButton(
                text: 'Generate Doctor-Ready Report',
                icon: Icons.auto_awesome_rounded,
                onPressed: () => _handleSubmitIntake(context, ref),
              ),
            ] else ...[
              // Prominent Circular Microphone Button (Image 8, 9, 10)
              MicRecordButton(
                status: status,
                onTap: () {
                  if (status.isRecording) {
                    notifier.stopRecording();
                  } else {
                    notifier.startRecording();
                  }
                },
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
