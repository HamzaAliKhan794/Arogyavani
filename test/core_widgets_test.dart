import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arogyavani/core/widgets/arogyavani_badge.dart';
import 'package:arogyavani/core/widgets/arogyavani_card.dart';
import 'package:arogyavani/core/widgets/step_dots_indicator.dart';
import 'package:arogyavani/core/widgets/dev_mode_banner.dart';
import 'package:arogyavani/core/widgets/test_otp_banner.dart';
import 'package:arogyavani/core/widgets/phone_text_field.dart';
import 'package:arogyavani/core/widgets/primary_button.dart';
import 'package:arogyavani/core/widgets/security_lock_footer.dart';

void main() {
  testWidgets('ArogyavaniBadge renders preset variants', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ArogyavaniBadge.patientPortal(),
              ArogyavaniBadge.doctorPortal(),
              ArogyavaniBadge.opdLive(),
              ArogyavaniBadge.soapReady(),
            ],
          ),
        ),
      ),
    );

    expect(find.text('PATIENT PORTAL'), findsOneWidget);
    expect(find.text('DOCTOR PORTAL'), findsOneWidget);
    expect(find.text('OPD Live'), findsOneWidget);
    expect(find.text('SOAP Ready'), findsOneWidget);
  });

  testWidgets('ArogyavaniCard triggers onTap callback', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArogyavaniCard(
            onTap: () => tapped = true,
            child: const Text('Test Card Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Card Content'), findsOneWidget);
    await tester.tap(find.text('Test Card Content'));
    expect(tapped, isTrue);
  });

  testWidgets('StepDotsIndicator renders correct step count', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StepDotsIndicator(totalSteps: 3, currentStep: 1),
        ),
      ),
    );

    expect(find.byType(StepDotsIndicator), findsOneWidget);
  });

  testWidgets('DevModeBanner displays development text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DevModeBanner(message: 'Testing banner display'),
        ),
      ),
    );

    expect(find.textContaining('Testing banner display', findRichText: true), findsOneWidget);
  });

  testWidgets('TestOtpBanner triggers auto-fill on tap', (tester) async {
    bool autofilled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TestOtpBanner(
            otpCode: '918957',
            onAutoFill: () => autofilled = true,
          ),
        ),
      ),
    );

    expect(find.text('918957'), findsOneWidget);
    await tester.tap(find.text('918957'));
    expect(autofilled, isTrue);
  });

  testWidgets('PhoneTextField renders +91 prefix and inputs number', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhoneTextField(controller: controller),
        ),
      ),
    );

    expect(find.text('+91'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '9876543210');
    expect(controller.text, '9876543210');
  });

  testWidgets('PrimaryButton renders text and loading indicator', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: 'Submit Button',
            isLoading: false,
          ),
        ),
      ),
    );

    expect(find.text('Submit Button'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: 'Submit Button',
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SecurityLockFooter renders default security text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SecurityLockFooter(),
        ),
      ),
    );

    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.textContaining('Encrypted, HIPAA & ABHA compliant'), findsOneWidget);
  });
}
