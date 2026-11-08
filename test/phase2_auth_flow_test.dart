import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arogyavani/main.dart';
import 'package:arogyavani/core/constants/app_strings.dart';
import 'package:arogyavani/core/widgets/test_otp_banner.dart';

void main() {
  testWidgets('Full Phase 2 Authentication Flow: Splash -> Role -> Patient Portal -> Phone -> OTP -> Dashboard',
      (WidgetTester tester) async {
    // 1. Launch App
    await tester.pumpWidget(
      const ProviderScope(
        child: ArogyavaniApp(),
      ),
    );

    // Initial Splash Screen
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);

    // Advance beyond splash timer
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // 2. Role Selection Screen
    expect(find.text(AppStrings.continueAs), findsOneWidget);
    expect(find.text(AppStrings.selectPortal), findsOneWidget);
    expect(find.text(AppStrings.imPatient), findsOneWidget);
    expect(find.text(AppStrings.imDoctor), findsOneWidget);

    // Tap "I'm a Patient"
    await tester.tap(find.text(AppStrings.imPatient));
    await tester.pumpAndSettle();

    // 3. Patient Portal Screen
    expect(find.text(AppStrings.patientAccount), findsOneWidget);
    expect(find.text(AppStrings.signIn), findsOneWidget);
    expect(find.text(AppStrings.createAccount), findsOneWidget);

    // Tap "Sign In"
    await tester.tap(find.text(AppStrings.signIn));
    await tester.pumpAndSettle();

    // 4. Mobile Auth Screen
    expect(find.text(AppStrings.signInWithMobile), findsOneWidget);
    expect(find.textContaining('Development Mode:', findRichText: true), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);

    // Tap "Get Verification Code"
    await tester.tap(find.text(AppStrings.getVerificationCode));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // 5. OTP Verification Screen
    expect(find.text(AppStrings.verifyCode), findsOneWidget);
    expect(find.text('918957'), findsOneWidget);
    expect(find.byType(TestOtpBanner), findsOneWidget);

    // Tap test OTP banner to auto-fill & verify
    await tester.tap(find.byType(TestOtpBanner));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // 6. Patient Dashboard Screen reached!
    expect(find.text(AppStrings.talkToArogyavani), findsOneWidget);
  });

  testWidgets('Phase 2 Doctor Flow is separated and accessible', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ArogyavaniApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Tap "I'm a Doctor"
    expect(find.text(AppStrings.imDoctor), findsOneWidget);
    await tester.tap(find.text(AppStrings.imDoctor));
    await tester.pumpAndSettle();

    // Doctor Portal Screen
    expect(find.text('Doctor Portal'), findsOneWidget);
    expect(find.text('Enter Doctor Consultation Hub'), findsOneWidget);

    // Sign In to Doctor Portal
    await tester.tap(find.text('Enter Doctor Consultation Hub'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Doctor Dashboard reached
    expect(find.text('Dr. Rajesh Sharma, MD'), findsOneWidget);
    expect(find.text('Scan Patient QR Code'), findsOneWidget);
  });
}
