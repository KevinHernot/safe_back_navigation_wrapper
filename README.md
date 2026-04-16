# Safe Back Navigation Wrapper

[![CI](https://github.com/KevinHernot/safe_back_navigation_wrapper/actions/workflows/ci.yml/badge.svg)](https://github.com/KevinHernot/safe_back_navigation_wrapper/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/tag/KevinHernot/safe_back_navigation_wrapper?label=release)](https://github.com/KevinHernot/safe_back_navigation_wrapper/releases)

Small, router-agnostic back-navigation helpers for Flutter apps.

`safe_back_navigation_wrapper` is a focused Flutter package for safe back-navigation handling. It keeps the useful part of the original component: safe handling of blocked back events and optional fallback navigation, without coupling the package to `go_router` or app-specific routes.

## What It Solves

- prevents accidental app exits on root screens
- gives you a fallback callback when the current route cannot pop
- keeps the API compatible with Flutter's modern `PopScope`
- works with `Navigator`, `go_router`, or any other routing layer

## Included Today

- `SafeBackNavigationWrapper`
- `SafeBackNavigationMixin`

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safe_back_navigation_wrapper/safe_back_navigation_wrapper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeBackNavigationWrapper(
      onFallbackNavigation: () => context.go('/home'),
      child: const Scaffold(
        body: Center(child: Text('Profile')),
      ),
    );
  }
}
```

The package itself does not depend on `go_router`. The callback above is only one possible integration style.

## Manual Pop Control

If you want to intercept the back action and decide yourself when the route should pop, set `canPop: false`. The wrapper will then try a manual `Navigator.pop()` before falling back.

```dart
SafeBackNavigationWrapper(
  canPop: false,
  onFallbackNavigation: () => Navigator.of(context).pushReplacementNamed('/'),
  child: const Scaffold(body: Text('Details')),
)
```

## Stateful Pages

```dart
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SafeBackNavigationMixin {
  @override
  void onSafeBackFallbackNavigation() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: safeBackCanPop,
      onPopInvokedWithResult: handleSafeBackNavigation,
      child: const Scaffold(
        body: Center(child: Text('Details')),
      ),
    );
  }
}
```

## Status

Early `0.1.0` public release.

## Development

```bash
flutter pub get
flutter analyze
flutter test
```

## Examples

- [example](example)
- [docs/API.md](docs/API.md)

## License

[MIT](LICENSE)
