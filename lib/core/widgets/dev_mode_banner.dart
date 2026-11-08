import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class DevModeBanner extends StatelessWidget {
  final String message;
  final String? title;

  const DevModeBanner({
    super.key,
    required this.message,
    this.title = 'Development Mode:',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.amberBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.amberBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: AppColors.amberWarning,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.amberWarning,
                  height: 1.45,
                  fontSize: 12.5,
                ),
                children: [
                  if (title != null)
                    TextSpan(
                      text: '$title ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  TextSpan(text: message),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
