import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class ExploreServicesSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onServiceTap;

  const ExploreServicesSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        children: [
          // Accordion Header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.star_outline_rounded,
                      color: Color(0xFFD97706),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Arogyavani',
                          style: AppStyles.heading3.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hospital & digital health services',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.borderSubtle),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
                childAspectRatio: 0.95,
                children: [
                  _ServiceTile(
                    title: 'Find Doctors',
                    icon: Icons.local_hospital_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: AppColors.medicalBlue,
                    onTap: () => onServiceTap('Find Doctors'),
                  ),
                  _ServiceTile(
                    title: 'Hospitals',
                    icon: Icons.location_on_outlined,
                    iconBg: const Color(0xFFFDF2F8),
                    iconColor: const Color(0xFFDB2777),
                    onTap: () => onServiceTap('Hospitals'),
                  ),
                  _ServiceTile(
                    title: 'Govt Schemes',
                    icon: Icons.verified_outlined,
                    iconBg: const Color(0xFFF0FDF4),
                    iconColor: AppColors.emeraldSuccess,
                    onTap: () => onServiceTap('Govt Schemes'),
                  ),
                  _ServiceTile(
                    title: 'Reminders',
                    icon: Icons.notifications_none_rounded,
                    iconBg: const Color(0xFFFFFBEB),
                    iconColor: const Color(0xFFD97706),
                    onTap: () => onServiceTap('Reminders'),
                  ),
                  _ServiceTile(
                    title: 'Emergency SOS',
                    icon: Icons.warning_amber_rounded,
                    iconBg: const Color(0xFFFEF2F2),
                    iconColor: AppColors.coralError,
                    onTap: () => onServiceTap('Emergency SOS'),
                  ),
                  _ServiceTile(
                    title: 'AI Assistant',
                    icon: Icons.smart_toy_outlined,
                    iconBg: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF7C3AED),
                    onTap: () => onServiceTap('AI Assistant'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle, width: 1),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.5,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
