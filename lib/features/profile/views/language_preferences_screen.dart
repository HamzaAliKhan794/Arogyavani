import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/profile_provider.dart';

class LanguagePreferencesScreen extends ConsumerStatefulWidget {
  const LanguagePreferencesScreen({super.key});

  @override
  ConsumerState<LanguagePreferencesScreen> createState() => _LanguagePreferencesScreenState();
}

class _LanguagePreferencesScreenState extends ConsumerState<LanguagePreferencesScreen> {
  late String _selectedAppLanguage;
  late String _selectedVoiceLanguage;

  static const List<Map<String, String>> appLanguages = [
    {'name': 'English', 'native': 'English', 'code': 'en'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'code': 'hi'},
    {'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'code': 'kn'},
    {'name': 'Telugu', 'native': 'తెలుగు', 'code': 'te'},
    {'name': 'Tamil', 'native': 'தமிழ்', 'code': 'ta'},
    {'name': 'Marathi', 'native': 'मराठी', 'code': 'mr'},
    {'name': 'Bengali', 'native': 'বাংলা', 'code': 'bn'},
  ];

  static const List<String> voiceLanguages = [
    'Hindi & English (Bilingual)',
    'Pure Hindi (हिन्दी)',
    'Pure English',
    'Regional (Kannada, Telugu, Tamil, Marathi)',
  ];

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(profileProvider).languagePreferences;
    _selectedAppLanguage = prefs.appLanguage;
    _selectedVoiceLanguage = prefs.voiceIntakeLanguage;
  }

  void _handleSave() {
    ref.read(profileProvider.notifier).setAppLanguage(_selectedAppLanguage);
    ref.read(profileProvider.notifier).setVoiceLanguage(_selectedVoiceLanguage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language preferences updated to "$_selectedAppLanguage".'),
        backgroundColor: AppColors.primaryTeal,
        duration: const Duration(seconds: 2),
      ),
    );

    context.pop();
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
            Text('Language Preferences', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Display language & AI voice recognition',
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                children: [
                  // Section 1: App Display Language
                  Text('App Display Language', style: AppStyles.heading3.copyWith(fontSize: 15)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                      boxShadow: AppStyles.cardShadow,
                    ),
                    child: Column(
                      children: appLanguages.map((lang) {
                        final isSelected = _selectedAppLanguage == lang['name'];
                        return InkWell(
                          onTap: () => setState(() => _selectedAppLanguage = lang['name']!),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang['native']!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                          color: isSelected ? AppColors.medicalBlue : AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        lang['name']!,
                                        style: AppStyles.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: AppColors.medicalBlue, size: 22)
                                else
                                  const Icon(Icons.radio_button_off_rounded, color: AppColors.textMuted, size: 20),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 2: AI Voice Intake Dialect
                  Text('Clinical Voice Intake Language', style: AppStyles.heading3.copyWith(fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(
                    'Choose the primary language you speak when describing symptoms to Arogyavani.',
                    style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                      boxShadow: AppStyles.cardShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: RadioGroup<String>(
                        groupValue: _selectedVoiceLanguage,
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedVoiceLanguage = val);
                        },
                        child: Column(
                          children: voiceLanguages.map((voice) {
                            return RadioListTile<String>(
                              value: voice,
                              title: Text(voice, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                              activeColor: AppColors.medicalBlue,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom Sticky Save Button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: PrimaryButton(
                text: 'Save Language Settings',
                icon: Icons.check_rounded,
                onPressed: _handleSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
