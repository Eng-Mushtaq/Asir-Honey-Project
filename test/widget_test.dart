import 'package:flutter_test/flutter_test.dart';
import 'package:asal_asir/main.dart';
import 'package:asal_asir/services/storage_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await StorageService.init();
    await tester.pumpWidget(const AsalAsirApp());
    expect(find.byType(AsalAsirApp), findsOneWidget);
  });
}
