import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

/// Standard Empty State View
class ArogyavaniEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ArogyavaniEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F5F9),
              ),
              child: Icon(icon, size: 30, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppStyles.heading3.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.medicalBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Standard Error State View with Retry
class ArogyavaniErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ArogyavaniErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFEE2E2),
              ),
              child: const Icon(Icons.error_outline_rounded, color: AppColors.coralError, size: 32),
            ),
            const SizedBox(height: 16),
            Text('Something went wrong', style: AppStyles.heading3.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              message,
              style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.medicalBlue,
                side: const BorderSide(color: AppColors.medicalBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Logout Confirmation Dialog
class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmLogout;

  const LogoutConfirmationDialog({
    super.key,
    required this.onConfirmLogout,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onConfirmLogout}) {
    return showDialog(
      context: context,
      builder: (context) => LogoutConfirmationDialog(onConfirmLogout: onConfirmLogout),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout_rounded, color: AppColors.coralError, size: 20),
          ),
          const SizedBox(width: 12),
          Text('Sign Out', style: AppStyles.heading3.copyWith(fontSize: 18)),
        ],
      ),
      content: Text(
        'Are you sure you want to sign out of Arogyavani? Your health records and encrypted passes will remain safe in your local vault.',
        style: AppStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          height: 1.45,
          fontSize: 13,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmLogout();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coralError,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
