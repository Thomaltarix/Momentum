import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/app.dart';

void main() {
  testWidgets('renders the placeholder home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MomentumApp()));

    expect(find.text('Momentum'), findsOneWidget);
  });
}
