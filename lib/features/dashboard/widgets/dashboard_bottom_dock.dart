import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class DashboardBottomDock extends StatelessWidget {
  final int activeIndex; // 0: Home, 1: OPD Queue, 3: Records, 4: Account
  final ValueChanged<int> onTabSelected;
  final VoidCallback onMicPressed;

  const DashboardBottomDock({
    super.key,
    required this.activeIndex,
    required this.onTabSelected,
    required this.onMicPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        border: const Border(
          top: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              // 1. Home
              Expanded(
                child: _DockItem(
                  label: 'Home',
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  isActive: activeIndex == 0,
                  onTap: () => onTabSelected(0),
                ),
              ),
              // 2. OPD Queue
              Expanded(
                child: _DockItem(
                  label: 'OPD Queue',
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month_rounded,
                  isActive: activeIndex == 1,
                  onTap: () => onTabSelected(1),
                ),
              ),
              // 3. Center Elevated Mic Button
              GestureDetector(
                onTap: onMicPressed,
                child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.medicalBlueLight,
                        AppColors.medicalBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.medicalBlue.withValues(alpha: 0.42),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mic_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              // 4. Records
              Expanded(
                child: _DockItem(
                  label: 'Records',
                  icon: Icons.description_outlined,
                  activeIcon: Icons.description_rounded,
                  isActive: activeIndex == 2,
                  onTap: () => onTabSelected(2),
                ),
              ),
              // 5. Account
              Expanded(
                child: _DockItem(
                  label: 'Account',
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  isActive: activeIndex == 3,
                  onTap: () => onTabSelected(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;

  const _DockItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.medicalBlue : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppStyles.bodySmall.copyWith(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
