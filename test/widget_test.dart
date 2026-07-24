import 'package:flutter_test/flutter_test.dart';
import 'package:aurasense/main.dart';

void main() {
  testWidgets('AuraSense smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AuraSenseApp());
  });
}