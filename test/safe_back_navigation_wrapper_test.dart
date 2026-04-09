import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_back_navigation_wrapper/safe_back_navigation_wrapper.dart';

void main() {
  testWidgets('calls fallback when the current route cannot pop', (
    tester,
  ) async {
    var fallbackCount = 0;
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: SafeBackNavigationWrapper(
          canPop: false,
          onFallbackNavigation: () {
            fallbackCount++;
          },
          child: const Scaffold(body: Center(child: Text('Root'))),
        ),
      ),
    );

    await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();

    expect(fallbackCount, 1);
    expect(find.text('Root'), findsOneWidget);
  });

  testWidgets('allows a nested route to pop normally', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(_TestApp(navigatorKey: navigatorKey));

    await tester.tap(find.text('Open details'));
    await tester.pumpAndSettle();

    expect(find.text('Details'), findsOneWidget);

    final handled = await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();

    expect(handled, isTrue);
    expect(find.text('Open details'), findsOneWidget);
    expect(find.text('Details'), findsNothing);
  });

  testWidgets('can intercept and manually pop when canPop is false', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(_ManualPopApp(navigatorKey: navigatorKey));

    await tester.tap(find.text('Open guarded details'));
    await tester.pumpAndSettle();

    expect(find.text('Guarded details'), findsOneWidget);

    final handled = await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();

    expect(handled, isTrue);
    expect(find.text('Open guarded details'), findsOneWidget);
    expect(find.text('Guarded details'), findsNothing);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SafeBackNavigationWrapper(
                        child: Scaffold(body: Center(child: Text('Details'))),
                      ),
                    ),
                  );
                },
                child: const Text('Open details'),
              ),
            ),
          ),
        ),
      );
}

class _ManualPopApp extends StatelessWidget {
  const _ManualPopApp({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SafeBackNavigationWrapper(
                        canPop: false,
                        child: Scaffold(
                            body: Center(child: Text('Guarded details'))),
                      ),
                    ),
                  );
                },
                child: const Text('Open guarded details'),
              ),
            ),
          ),
        ),
      );
}
