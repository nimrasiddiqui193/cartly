import 'package:flutter_test/flutter_test.dart';
import 'package:cartly/main.dart';

void main() {
  testWidgets('Cartly app launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const CartlyApp());

    expect(find.text('Cartly'), findsWidgets);
  });
}
