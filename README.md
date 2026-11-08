# Arogyavani (आरोग्यवाणी)
### AI-Powered Clinical Voice Intake & Smart OPD Consultation System

A modern, ABDM-aligned cross-platform healthcare application built with **Flutter**, **Riverpod 3.x**, and **GoRouter**. Arogyavani bridges the patient-doctor communication gap in busy outpatient departments (OPDs) by converting natural multilingual patient voice input into doctor-ready clinical SOAP notes, managing encrypted digital health records, and enabling secure, time-limited QR access sharing.

---

## 🌟 Key Capabilities

### 🩺 Patient Journey
- **Multilingual Clinical Voice Intake**: Speaks naturally in Hindi, English, or regional Indian languages; features real-time audio waveform visualization and preview playback.
- **AI Medical Scribe**: Automated pipeline simulation (Faster-Whisper Speech-to-Text & clinical structuring) formatting Chief Complaints, History of Present Illness (HPI), and Provisional Assessments.
- **Doctor-Ready Clinical Summary**: Clean, structured physician-grade report with provisional clinical plans and expandable spoken transcripts.
- **Encrypted Health Records Vault**: Categorized repository for OPD visits, diagnostic lab reports with out-of-range panic indicators, and digital prescription slips.
- **Clinical Document Upload**: Camera / Gallery / Files picker interface with automated metadata tagging and document categorization.
- **Time-Limited Doctor Access Pass**: 15-minute countdown QR code (`qr_flutter`) with single-session backup PIN (`AV-4892`) and instant revocation controls.
- **ABDM Digital Health Profile**: Verified ABHA ID card (`91-8842-1920-4921`) with one-tap clipboard copy, vitals row, emergency contact, and privacy consent management.

### 👨‍⚕️ Clinician Terminal Journey
- **Doctor Consultation Hub**: Dedicated dashboard for Dr. Rajesh Sharma, MD, with live OPD queue management and consultation token counters.
- **Doctor QR Optical Scanner**: Viewfinder with animated laser line, torch toggle, camera scan simulation, manual access PIN fallback, and decrypted single-session consultation modal.
- **Terminal Preferences**: Configurable consultation slot pacing (10 / 15 / 20 min), auto-expand SOAP summary toggles, and emergency triage prioritization.
- **Clinical Escalation Alerts**: Dedicated notification switches for critical STAT panic-range lab values and emergency distress arrivals.

---

## 🏗️ Architecture & Tech Stack

- **Framework**: Flutter 3.x & Dart 3.x (Web, Android, iOS, Desktop)
- **State Management**: Flutter Riverpod 3.x (`Notifier` & `NotifierProvider`)
- **Navigation & Routing**: `go_router` 14.x with strict patient/doctor route separation
- **Design System**:
  - Primary Clinical Teal: `#0B5D6E`
  - Medical Blue: `#1A73E8`
  - Emerald Success: `#059669`
  - Warning Amber: `#D97706`
  - Coral Error / Emergency: `#DC2626`
  - Clean Off-White Surface: `#F8FAFC`
- **QR Generation**: `qr_flutter`
- **Date Formatting**: `intl`

---

## 📱 Application Flow & Routes

```
[Splash Screen (/)]
        │
  [Role Selection (/role-selection)]
   ├── Patient Pathway
   │     ├── Patient Portal (/patient-portal)
   │     ├── Phone Authentication (/phone-auth)
   │     ├── OTP Verification (/otp-verification)
   │     └── Patient Dashboard (/patient-dashboard)
   │           ├── Clinical Voice Intake (Modal Sheet)
   │           ├── AI Scribe Processing (/ai-scribe)
   │           ├── Doctor-Ready Clinical Report (/clinical-report)
   │           ├── Medical Records Vault (/records)
   │           │     ├── OPD Visits History (/records/opd-visits)
   │           │     ├── Diagnostic Lab Reports (/records/lab-reports)
   │           │     ├── Digital Prescriptions (/records/prescriptions)
   │           │     ├── Document Upload (/records/upload)
   │           │     └── Document Preview & Tagging (/records/preview)
   │           ├── Doctor Access Pass QR (/records/doctor-qr)
   │           │     ├── Share Configuration (/records/configure-share)
   │           │     └── Share Access Audit Logs (/records/access-status)
   │           └── Patient Profile & Settings (/patient/profile)
   │                 ├── Edit Personal Information (/patient/edit-profile)
   │                 ├── Account & Security Settings (/patient/settings)
   │                 ├── Notification Preferences (/settings/notifications)
   │                 ├── Language & Speech Preferences (/settings/language)
   │                 ├── Privacy, Consent & Vault (/settings/privacy)
   │                 └── Help & National Helplines (/settings/help)
   │
   └── Doctor Terminal Pathway
         ├── Doctor Portal (/doctor-portal)
         └── Doctor Dashboard (/doctor-dashboard)
               ├── Doctor QR Optical Scanner (/doctor/scan-qr)
               ├── Doctor Clinical Profile (/doctor/profile)
               ├── Doctor Account Settings (/doctor/settings)
               ├── Consultation Pacing Preferences (/doctor/consultation-preferences)
               ├── Doctor Notification Settings (/doctor/notifications)
               └── Doctor Clinical Guide & Support (/doctor/help)
```

---

## 🧪 Testing & Code Quality

The codebase maintains **100% clean static analysis** and a comprehensive automated test suite:

```bash
# Run static analysis
flutter analyze

# Run all 48 automated test cases across 7 development phases
flutter test

# Build for Web
flutter build web --no-tree-shake-icons
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.3.0)
- Dart SDK (>= 3.3.0)

### Installation
```bash
# Clone the repository
git clone https://github.com/HamzaAliKhan794/Arogyavani.git
cd Arogyavani

# Install dependencies
flutter pub get

# Run on Chrome / Web
flutter run -d chrome

# Or run on connected mobile device / emulator
flutter run
```

---

## 🔒 Security & Privacy Notice
All patient and doctor records included in this repository are **fictional archetypes** designed for clinical evaluation. No real personal health information (PHI) or live ABDM production keys are contained in this codebase.
