import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';

class HeroIntakeCard extends StatelessWidget {
  final VoidCallback onStartIntake;

  const HeroIntakeCard({
    super.key,
    required this.onStartIntake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F4C81), // Deep Clinical Slate Teal
            Color(0xFF1E3A8A), // Deep Medical Blue
            Color(0xFF172554), // Dark Navy accent
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ECG / Medical Wave subtle vector
          Positioned.fill(
            child: CustomPaint(
              painter: _MedicalWavePainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag Badges Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 13, color: Colors.white),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'AI CLINICAL INTAKE',
                                style: AppStyles.badgeText.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF166534), // Forest Green badge
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'SOAP Ready',
                        style: AppStyles.badgeText.copyWith(
                          color: const Color(0xFF86EFAC),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Heading & Mic bubble row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.talkToArogyavani,
                            style: AppStyles.heading2.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.intakeHeroDesc,
                            style: AppStyles.bodySmall.copyWith(
                              color: const Color(0xFFE2E8F0),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Floating circular mic bubble
                    GestureDetector(
                      onTap: onStartIntake,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE0EDFF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          color: AppColors.medicalBlue,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Start Clinical Intake Primary Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onStartIntake,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.medicalBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mic_none_rounded, size: 20, color: Colors.white),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            AppStrings.startClinicalIntake,
                            style: AppStyles.buttonText.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Footer Value Props Row
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: 14, color: Color(0xFF67E8F9)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              AppStrings.languageSupport,
                              style: AppStyles.bodySmall.copyWith(
                                color: const Color(0xFFCFFAFE),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.check, size: 14, color: Color(0xFF86EFAC)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              AppStrings.summaryGrade,
                              style: AppStyles.bodySmall.copyWith(
                                color: const Color(0xFFDCFCE7),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final path = Path();
    path.moveTo(0, size.height * 0.55);
    path.lineTo(size.width * 0.3, size.height * 0.55);
    path.lineTo(size.width * 0.35, size.height * 0.42);
    path.lineTo(size.width * 0.42, size.height * 0.72);
    path.lineTo(size.width * 0.48, size.height * 0.28);
    path.lineTo(size.width * 0.54, size.height * 0.65);
    path.lineTo(size.width * 0.58, size.height * 0.55);
    path.lineTo(size.width, size.height * 0.55);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
