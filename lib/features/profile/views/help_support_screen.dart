import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _selectedTopic = 'Voice Intake & Speech';

  static const List<Map<String, String>> faqs = [
    {
      'q': 'How does Arogyavani\'s AI Clinical Voice Intake work?',
      'a': 'When you speak into the microphone, our speech engine processes your natural words in Hindi, English or regional languages. It structures your symptoms into standard clinical SOAP sections (Subjective symptoms, HPI narrative, and Provisional Assessment) so your doctor can review your story before your turn.',
    },
    {
      'q': 'Does the AI replace the doctor\'s consultation?',
      'a': 'Never. Arogyavani\'s summaries are strictly provisional intake notes for doctor review. Only your licensed consulting physician can evaluate vitals, perform physical examinations, confirm diagnoses, and prescribe treatments.',
    },
    {
      'q': 'How do I share my health summary with the doctor?',
      'a': 'Tap the "Doctor QR" tile on your dashboard or in Medical Records. Show the generated high-contrast QR code (or read out your 6-digit PIN) to the doctor or nurse at the consultation desk. The pass automatically expires after 15 minutes.',
    },
    {
      'q': 'What is an ABHA Health ID?',
      'a': 'Ayushman Bharat Health Account (ABHA) is India\'s national digital health identifier. It lets you link verified lab reports and hospital consultation records across all public and private ABDM-compliant health providers.',
    },
    {
      'q': 'Can I revoke the doctor\'s access to my records?',
      'a': 'Yes, at any time. Go to Doctor QR -> Revoke Doctor Access Now, or visit the Access Logs screen to instantly terminate the active consultation token.',
    },
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _handleSubmitTicket() {
    if (_queryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your query before submitting.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support ticket submitted! Ticket #AG-8821 created. We will reply within 2 hours.'),
        backgroundColor: AppColors.primaryTeal,
        duration: Duration(seconds: 3),
      ),
    );
    _queryController.clear();
  }

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
            Text('Help & Support', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'FAQs, 24/7 Helplines & Patient Assistance',
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
            // National Emergency Helpline Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.emergency_outlined, color: AppColors.coralError, size: 22),
                      SizedBox(width: 8),
                      Text(
                        '24/7 National Emergency Helplines',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.coralError),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HelplinePill(number: '1075', label: 'National Health'),
                      _HelplinePill(number: '108', label: 'Ambulance SOS'),
                      _HelplinePill(number: '102', label: 'Pregnancy Care'),
                      _HelplinePill(number: '112', label: 'Emergency All'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FAQs Accordion
            Text('Frequently Asked Questions', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            ...faqs.map((faq) {
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
            const SizedBox(height: 24),

            // Contact Support Desk
            Text('Submit a Support Query', style: AppStyles.heading3.copyWith(fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedTopic,
                    decoration: const InputDecoration(labelText: 'Topic'),
                    items: [
                      'Voice Intake & Speech',
                      'Doctor QR Sharing',
                      'ABHA Card Linking',
                      'Lab Reports Download',
                      'Other Feedback',
                    ].map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedTopic = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _queryController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Describe your issue or suggestion',
                      hintText: 'Tell us how we can assist you...',
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _handleSubmitTicket,
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Submit Support Request'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.medicalBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HelplinePill extends StatelessWidget {
  final String number;
  final String label;

  const _HelplinePill({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: [
          Text(number, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.coralError)),
          Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
