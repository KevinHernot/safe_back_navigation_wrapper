import 'package:flutter/material.dart';
import 'package:safe_back_navigation_wrapper/safe_back_navigation_wrapper.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Safe Back Navigation Wrapper Demo',
    theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _fallbackCount = 0;

  @override
  Widget build(BuildContext context) => SafeBackNavigationWrapper(
    onFallbackNavigation: () {
      setState(() {
        _fallbackCount++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fallback triggered $_fallbackCount time${_fallbackCount == 1 ? '' : 's'}.',
          ),
        ),
      );
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Safe Back Navigation Wrapper')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This root page cannot pop, so a back press triggers the fallback callback instead.',
            ),
            const SizedBox(height: 16),
            Text('Fallback count: $_fallbackCount'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const DetailsPage()),
                );
              },
              child: const Text('Open details page'),
            ),
          ],
        ),
      ),
    ),
  );
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) => const SafeBackNavigationWrapper(
    canPop: false,
    child: Scaffold(
      body: Center(
        child: Text(
          'This page sets canPop to false.\n'
          'The wrapper manually calls Navigator.pop() when possible.',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
