import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/security_providers.dart';
import 'lock_screen.dart';

/// v2.0 — wraps the app root. Renders nothing until the security state is
/// bootstrapped (prevents any content flash before the lock decision),
/// then either the child or the full-screen lock.
///
/// Also drives idle auto-lock (D-030): background → record, resume →
/// evaluate elapsed vs the configured timeout.
class LockGate extends ConsumerStatefulWidget {
  final Widget child;
  const LockGate({super.key, required this.child});

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(securityProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        notifier.onPaused();
      case AppLifecycleState.resumed:
        notifier.onResumed();
        if (mounted) setState(() {});
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final security = ref.watch(securityProvider);
    if (!security.ready) return const SizedBox.shrink();
    if (security.isLocked) return const LockScreen();
    return widget.child;
  }
}
