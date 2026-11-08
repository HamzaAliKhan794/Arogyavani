import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arogyavani/main.dart';
import 'package:arogyavani/core/constants/app_strings.dart';

void main() {
  testWidgets('Arogyavani app initializes with splash and branding', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ArogyavaniApp(),
      ),
    );

    // Verify brand name and tagline exist
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);
  });
}
