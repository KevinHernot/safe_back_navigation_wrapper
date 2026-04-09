import 'package:flutter/material.dart';

/// Shared back-navigation behavior for stateful pages.
///
/// Use this mixin when you prefer wiring [PopScope] manually inside your page
/// instead of wrapping the full subtree with [SafeBackNavigationWrapper].
mixin SafeBackNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Mirrors [PopScope.canPop].
  bool get safeBackCanPop => true;

  /// When `true`, manual handling will still try [Navigator.pop] first.
  bool get safeBackAttemptNavigatorPop => true;

  /// Override to observe the pop attempt.
  void onSafeBackPopInvoked({required bool didPop, Object? result}) {}

  /// Override to send the user to a safe fallback destination.
  void onSafeBackFallbackNavigation() {}

  /// Pass this method directly to [PopScope.onPopInvokedWithResult].
  void handleSafeBackNavigation(bool didPop, Object? result) {
    onSafeBackPopInvoked(didPop: didPop, result: result);

    if (didPop || !mounted) {
      return;
    }

    if (safeBackAttemptNavigatorPop) {
      final navigator = Navigator.maybeOf(context);
      if (navigator != null && navigator.canPop()) {
        navigator.pop();
        return;
      }
    }

    onSafeBackFallbackNavigation();
  }

  /// Imperative helper for custom back buttons.
  Future<void> goBack() async {
    if (!mounted) {
      return;
    }

    if (safeBackAttemptNavigatorPop) {
      final navigator = Navigator.maybeOf(context);
      if (navigator != null && navigator.canPop()) {
        navigator.pop();
        return;
      }
    }

    onSafeBackFallbackNavigation();
  }
}
