// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:cat_directory_app/app/app.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App renders home title', (WidgetTester tester) async {
    final testRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Cat Directory'))),
        ),
      ],
    );

    await tester.pumpWidget(CatDirectoryApp(router: testRouter));

    expect(find.text('Cat Directory'), findsOneWidget);
  });
}
