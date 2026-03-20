import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflowapp/core/theme/app_theme.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/surface_card.dart';
import 'package:taskflowapp/features/auth/presentation/widget/log_in_input.dart';

void main() {
  group('Golden tests', () {
    testWidgets('PrimaryButton golden', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: PrimaryButton(
                  label: 'Log In',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(PrimaryButton),
        matchesGoldenFile('goldens/primary_button.png'),
      );
    });

    testWidgets('SurfaceCard with LogInInput golden', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: SurfaceCard(
                  child: LogInInput(
                    emailController: TextEditingController(),
                    passwordController: TextEditingController(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(SurfaceCard),
        matchesGoldenFile('goldens/surface_card_login_input.png'),
      );
    });
  });
}
