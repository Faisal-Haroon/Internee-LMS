import 'package:flutter_test/flutter_test.dart';
import 'package:internee_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const InterneeApp());
  });
}
