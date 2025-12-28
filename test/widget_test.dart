import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfs_mounter/main.dart';

void main() {
  testWidgets('App title smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NFSMounterApp());

    // Verify that the title is displayed.
    expect(find.text('NFS Station'), findsOneWidget);
    // There shouldn't be any counter stuff
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
