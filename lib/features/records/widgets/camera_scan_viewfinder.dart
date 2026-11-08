import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class CameraScanViewfinder extends StatefulWidget {
  final ValueChanged<String> onCodeScanned;
  final VoidCallback onManualPinTap;

  const CameraScanViewfinder({
    super.key,
    required this.onCodeScanned,
    required this.onManualPinTap,
  });

  @override
  State<CameraScanViewfinder> createState() => _CameraScanViewfinderState();
}

class _CameraScanViewfinderState extends State<CameraScanViewfinder> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scanAnimation;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const scanBoxSize = 250.0;

    return Column(
      children: [
        // Camera Viewfinder Box
        Center(
          child: Container(
            width: scanBoxSize,
            height: scanBoxSize,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Stack(
              children: [
                // 4 Corner Brackets
                const _CornerBracket(alignment: Alignment.topLeft),
                const _CornerBracket(alignment: Alignment.topRight),
                const _CornerBracket(alignment: Alignment.bottomLeft),
                const _CornerBracket(alignment: Alignment.bottomRight),

                // Animated Laser Line
                AnimatedBuilder(
                  animation: _scanAnimation,
                  builder: (context, child) {
                    return Positioned(
                      top: 15 + _scanAnimation.value * (scanBoxSize - 35),
                      left: 12,
                      right: 12,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.emeraldSuccess,
                              Colors.white,
                              AppColors.emeraldSuccess,
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emeraldSuccess.withValues(alpha: 0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Center Guideline Crosshair
                Center(
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Torch and Manual PIN action bar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: () {
                setState(() => _isTorchOn = !_isTorchOn);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isTorchOn ? 'Torch turned ON' : 'Torch turned OFF'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(
                _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                color: _isTorchOn ? AppColors.warningText : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: widget.onManualPinTap,
              icon: const Icon(Icons.dialpad_rounded, size: 16),
              label: const Text('Enter 6-Digit PIN'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.medicalBlue,
                side: const BorderSide(color: AppColors.borderSubtle),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        // Quick Simulated Scan Action for Testing
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.science_outlined, size: 18, color: AppColors.medicalBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Development Mode Scanner Demo',
                    style: AppStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.medicalBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Simulate doctor optical camera detecting patient QR code payload or PIN verification.',
                style: AppStyles.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => widget.onCodeScanned('arogyavani://session/SES-9955-4892?pin=AV-4892&token=Token%20%2312'),
                  icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                  label: const Text('Simulate Scan: HAMZALI KHAN (Token #12)'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.medicalBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final Alignment alignment;
  const _CornerBracket({required this.alignment});

  @override
  Widget build(BuildContext context) {
    const size = 24.0;
    const thickness = 3.5;
    const radius = 6.0;

    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              color: AppColors.emeraldSuccess,
              thickness: thickness,
              isTop: isTop,
              isLeft: isLeft,
              radius: radius,
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isTop;
  final bool isLeft;
  final double radius;

  _CornerPainter({
    required this.color,
    required this.thickness,
    required this.isTop,
    required this.isLeft,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height - radius);
      path.quadraticBezierTo(0, size.height, radius, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width - radius, size.height);
      path.quadraticBezierTo(size.width, size.height, size.width, size.height - radius);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
