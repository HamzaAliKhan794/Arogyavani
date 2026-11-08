import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class ArogyavaniCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool hasShadow;

  const ArogyavaniCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppStyles.radiusCard,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadii = BorderRadius.circular(borderRadius);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardSurface,
        borderRadius: borderRadii,
        border: Border.all(
          color: borderColor ?? AppColors.borderSubtle,
          width: 1,
        ),
        boxShadow: hasShadow ? AppStyles.cardShadow : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: borderRadii,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadii,
          splashColor: AppColors.medicalBlueSoft,
          highlightColor: AppColors.secondarySurface,
          child: content,
        ),
      );
    }

    return content;
  }
}
