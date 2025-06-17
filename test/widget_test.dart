import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:work_schedule_app/main.dart';

void main() {
  testWidgets('Work Schedule app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WorkScheduleApp());

    // Verify that our app starts with the title
    expect(find.text('Planning de Travail'), findsOneWidget);

    // Verify that we have the import button
    expect(find.text('Importer CSV'), findsOneWidget);
  });
}