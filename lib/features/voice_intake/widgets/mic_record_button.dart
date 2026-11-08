import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/voice_intake_state.dart';

class MicRecordButton extends StatefulWidget {
  final IntakeRecordingStatus status;
  final VoidCallback onTap;

  const MicRecordButton({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  State<MicRecordButton> createState() => _MicRecordButtonState();
}

class _MicRecordButtonState extends State<MicRecordButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.status.isRecording) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MicRecordButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status.isRecording && !oldWidget.status.isRecording) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.status.isRecording && oldWidget.status.isRecording) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = widget.status.isRecording;
    final isCaptured = widget.status.isCaptured;
    final isPlaying = widget.status.isPlaying;

    IconData icon;
    if (isRecording) {
      icon = Icons.stop_rounded;
    } else if (isPlaying) {
      icon = Icons.pause_rounded;
    } else if (isCaptured) {
      icon = Icons.play_arrow_rounded;
    } else {
      icon = Icons.mic_rounded;
    }

    return Center(
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final scale = isRecording ? _pulseAnimation.value : 1.0;

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording ? AppColors.coralError : AppColors.medicalBlue,
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording ? AppColors.coralError : AppColors.medicalBlue)
                          .withValues(alpha: isRecording ? 0.45 : 0.35),
                      blurRadius: isRecording ? 24 : 16,
                      spreadRadius: isRecording ? 4 : 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
