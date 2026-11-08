import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class DoctorHelpSupportScreen extends StatelessWidget {
  const DoctorHelpSupportScreen({super.key});

  static const List<Map<String, String>> doctorFaqs = [
    {
      'q': 'How do I scan the patient\'s clinical QR pass?',
      'a': 'From your Doctor Dashboard, tap "Scan Patient QR Code". Position the patient\'s phone within the camera viewfinder brackets. The terminal will immediately verify the 256-bit token and display the patient\'s Chief Complaints, HPI narrative, and lab history.',
    },
    {
      'q': 'What if the patient cannot display their QR code?',
      'a': 'Patients have an alphanumeric 6-character backup PIN (e.g. "AV-4892") directly under their QR code. Tap "Enter 6-Digit PIN" on your scanner terminal to pull up their consultation records manually.',
    },
    {
      'q': 'Can I edit or override the AI Medical Scribe SOAP summary?',
      'a': 'Yes. All AI-generated SOAP notes are strictly provisional informational intake summaries. You have absolute clinical discretion to modify, augment, or completely supersede any clinical recommendation or diagnosis before saving the consultation note.',
    },
    {
      'q': 'How are digital prescriptions signed?',
      'a': 'When your USB DSC key or institutional hospital token is connected, prescriptions generated through Arogyavani are automatically stamped with your NMC/MCI registration number and digital cryptographic signature.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor Clinical Guide', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Physician Assistance & Terminal Support',
              style: AppStyles.bodySmall.copyWith(
                color: AppColors.medicalBlue,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            // Physician Support Line
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.support_agent_rounded, color: AppColors.medicalBlue, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Physician IT Support Line', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                        SizedBox(height: 2),
                        Text('Direct Priority Line: +91 800-DOCTOR-AG\nEmail: doctor.support@arogyavani.in', style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.35)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Clinical FAQs
            Text('Clinical FAQ & Workflow Guide', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            ...doctorFaqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle, width: 1),
                  boxShadow: AppStyles.cardShadow,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      title: Text(
                        faq['q']!,
                        style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                      children: [
                        Text(
                          faq['a']!,
                          style: AppStyles.bodySmall.copyWith(fontSize: 12.5, color: AppColors.textSecondary, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
