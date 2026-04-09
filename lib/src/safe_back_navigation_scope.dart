import 'package:flutter/material.dart';

/// Called whenever Flutter invokes a pop attempt for the wrapped subtree.
typedef SafeBackNavigationPopCallback = void Function(
    {required bool didPop, Object? result});

/// A small [PopScope]-based wrapper that safely handles blocked back actions.
///
/// The wrapper is intentionally router-agnostic:
/// - if the current route can pop, Flutter or the wrapper uses [Navigator]
/// - if it cannot pop, [onFallbackNavigation] is called
///
/// This makes the widget easy to integrate with `Navigator`, `go_router`, or
/// custom routing layers.
class SafeBackNavigationWrapper extends StatelessWidget {
  const SafeBackNavigationWrapper({
    required this.child,
    super.key,
    this.canPop = true,
    this.attemptNavigatorPop = true,
    this.onPopInvoked,
    this.onFallbackNavigation,
  });

  /// The wrapped page or subtree.
  final Widget child;

  /// Mirrors [PopScope.canPop].
  ///
  /// Set this to `false` when you want to intercept the back action and let the
  /// wrapper decide whether to pop manually or call the fallback.
  final bool canPop;

  /// When `true`, the wrapper tries `Navigator.pop()` if the route stack can
  /// still pop after Flutter reports a blocked pop event.
  final bool attemptNavigatorPop;

  /// Optional observer callback that receives the result of the pop attempt.
  final SafeBackNavigationPopCallback? onPopInvoked;

  /// Called when no route can be popped safely.
  ///
  /// This is typically where callers redirect to a known screen with their own
  /// router, for example `context.go('/home')`.
  final VoidCallback? onFallbackNavigation;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) {
          onPopInvoked?.call(didPop: didPop, result: result);

          if (didPop) {
            return;
          }

          _handleBlockedPop(context);
        },
        child: child,
      );

  void _handleBlockedPop(BuildContext context) {
    if (attemptNavigatorPop) {
      final navigator = Navigator.maybeOf(context);
      if (navigator != null && navigator.canPop()) {
        navigator.pop();
        return;
      }
    }

    onFallbackNavigation?.call();
  }
}
