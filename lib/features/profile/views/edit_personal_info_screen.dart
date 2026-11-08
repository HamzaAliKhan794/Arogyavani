import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/profile_provider.dart';

class EditPersonalInfoScreen extends ConsumerStatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  ConsumerState<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends ConsumerState<EditPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _addressController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  late String _selectedGender;
  late String _selectedBloodGroup;
  late DateTime _selectedDob;

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileProvider).patientProfile;
    _nameController = TextEditingController(text: p.fullName);
    _emailController = TextEditingController(text: p.email);
    _emergencyNameController = TextEditingController(text: p.emergencyContactName);
    _emergencyPhoneController = TextEditingController(text: p.emergencyContactPhone);
    _addressController = TextEditingController(text: p.address);
    _heightController = TextEditingController(text: p.heightCm.toInt().toString());
    _weightController = TextEditingController(text: p.weightKg.toInt().toString());

    _selectedGender = p.gender;
    _selectedBloodGroup = p.bloodGroup;
    _selectedDob = p.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _addressController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final height = double.tryParse(_heightController.text) ?? 175.0;
      final weight = double.tryParse(_weightController.text) ?? 68.0;

      ref.read(profileProvider.notifier).updatePatientProfile(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            gender: _selectedGender,
            dateOfBirth: _selectedDob,
            bloodGroup: _selectedBloodGroup,
            emergencyContactName: _emergencyNameController.text.trim(),
            emergencyContactPhone: _emergencyPhoneController.text.trim(),
            address: _addressController.text.trim(),
            heightCm: height,
            weightKg: weight,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personal profile information updated successfully!'),
          backgroundColor: AppColors.primaryTeal,
          duration: Duration(seconds: 2),
        ),
      );

      if (GoRouter.maybeOf(context) != null) {
        context.pop();
      } else {
        Navigator.of(context).maybePop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    const bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    const genders = ['Male', 'Female', 'Other'];

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
            Text('Edit Personal Information', style: AppStyles.heading3.copyWith(fontSize: 16.5)),
            Text(
              'Update your verified health details',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name (as per Aadhaar / ABHA)',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Please enter your full name';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Please enter your email';
                          if (!val.contains('@')) return 'Enter a valid email address';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Gender & Blood Group Row
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedGender,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: Icon(Icons.wc_rounded),
                              ),
                              items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedGender = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedBloodGroup,
                              decoration: const InputDecoration(
                                labelText: 'Blood Group',
                                prefixIcon: Icon(Icons.bloodtype_outlined),
                              ),
                              items: bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedBloodGroup = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Date of Birth Selector
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDob,
                            firstDate: DateTime(1930),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedDob = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSubtle, width: 1.2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.cake_outlined, size: 20, color: AppColors.medicalBlue),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Date of Birth: ${dateFormat.format(_selectedDob)}',
                                    style: AppStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.edit_calendar_rounded, size: 18, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Height & Weight Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Height (cm)',
                                prefixIcon: Icon(Icons.height_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Weight (kg)',
                                prefixIcon: Icon(Icons.monitor_weight_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Emergency Contact Section
                      Text('Emergency Contact Details:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emergencyNameController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Name & Relation (e.g. Fatima Khan - Mother)',
                          prefixIcon: Icon(Icons.contact_phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emergencyPhoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Emergency Mobile Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Residential Address
                      Text('Residential Address:', style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.home_outlined),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
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
                text: 'Save Profile Changes',
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
