import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_app/app/app.dart';

void main() {
  testWidgets('app builds', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}
