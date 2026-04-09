# API Overview

## `SafeBackNavigationWrapper`

`SafeBackNavigationWrapper` is the main public widget.

It gives you:

- modern `PopScope` integration
- optional manual `Navigator.pop()` fallback
- a router-agnostic callback for redirecting elsewhere when no route can pop

### Main Parameters

- `child`: wrapped page or subtree
- `canPop`: forwarded to `PopScope`
- `attemptNavigatorPop`: whether to try `Navigator.pop()` during blocked pops
- `onPopInvoked`: observer callback for pop attempts
- `onFallbackNavigation`: called when no route can pop safely

## `SafeBackNavigationMixin`

The mixin provides the same behavior for stateful pages that already own their
own `PopScope`.

Useful members:

- `safeBackCanPop`
- `safeBackAttemptNavigatorPop`
- `handleSafeBackNavigation`
- `goBack()`
- `onSafeBackFallbackNavigation()`

## Typical `go_router` Integration

```dart
SafeBackNavigationWrapper(
  onFallbackNavigation: () => context.go('/home'),
  child: const Scaffold(
    body: Center(child: Text('Profile')),
  ),
)
```

## Typical `Navigator` Integration

```dart
SafeBackNavigationWrapper(
  onFallbackNavigation: () {
    Navigator.of(context).pushReplacementNamed('/');
  },
  child: const Scaffold(
    body: Center(child: Text('Profile')),
  ),
)
```
