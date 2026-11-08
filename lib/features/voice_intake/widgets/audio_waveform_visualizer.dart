import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/voice_intake_state.dart';

class AudioWaveformVisualizer extends StatelessWidget {
  final IntakeRecordingStatus status;
  final List<double> amplitudes;
  final double playbackProgress;

  const AudioWaveformVisualizer({
    super.key,
    required this.status,
    required this.amplitudes,
    this.playbackProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    const totalBars = 26;

    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF), // Soft clinical light blue
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDBEAFE),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(totalBars, (index) {
          double heightFactor = 0.15; // default rest height

          if (status.isRecording) {
            if (amplitudes.isNotEmpty) {
              final ampIndex = (index * amplitudes.length / totalBars).floor();
              if (ampIndex < amplitudes.length) {
                heightFactor = amplitudes[ampIndex].clamp(0.15, 1.0);
              }
            } else {
              heightFactor = (index % 3 == 0) ? 0.35 : 0.15;
            }
          } else if (status.isCaptured || status.isPlaying) {
            // Realistic voice envelope pattern
            final waveCurve = [
              0.15, 0.20, 0.35, 0.65, 0.85, 0.90, 0.70, 0.50, 0.40, 0.75, 0.95, 0.80,
              0.60, 0.45, 0.70, 0.85, 0.55, 0.35, 0.60, 0.75, 0.50, 0.30, 0.25, 0.20, 0.15, 0.15
            ];
            heightFactor = waveCurve[index % waveCurve.length];
          }

          final barHeight = (heightFactor * 40).clamp(6.0, 42.0);

          // Color logic
          Color barColor;
          if (status.isInitial || status.isError) {
            barColor = const Color(0xFFCBD5E1); // Muted slate dots (Image 8)
          } else if (status.isRecording) {
            barColor = AppColors.medicalBlue;
          } else if (status.isPlaying) {
            final barProgress = index / totalBars;
            barColor = barProgress <= playbackProgress
                ? AppColors.medicalBlue
                : const Color(0xFF94A3B8);
          } else {
            barColor = const Color(0xFF60A5FA); // Captured light blue (Image 9/10)
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeInOut,
            width: 4.5,
            height: barHeight,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }
}
