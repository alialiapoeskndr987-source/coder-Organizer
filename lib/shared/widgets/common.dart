import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/enums.dart';
import '../../core/theme/app_theme.dart';
import '../../features/paywall/paywall_screen.dart';
import '../../providers/core_providers.dart';

// ── l10n label helpers ────────────────────────────────────────────────
String nodeTypeLabel(AppLocalizations l10n, NodeType t) => switch (t) {
      NodeType.mainTab => l10n.mainTab,
      NodeType.subTab => l10n.subTab,
      NodeType.section => l10n.section,
      NodeType.project => l10n.project,
    };

String templateLabel(AppLocalizations l10n, NodeTemplate t) => switch (t) {
      NodeTemplate.client => l10n.tplClient,
      NodeTemplate.personal => l10n.tplPersonal,
      NodeTemplate.subscription => l10n.tplSubscription,
      NodeTemplate.quickNote => l10n.tplQuickNote,
      NodeTemplate.custom => l10n.tplCustom,
    };

String linkCategoryLabel(AppLocalizations l10n, LinkCategory c) =>
    switch (c) {
      LinkCategory.repository => l10n.linkRepository,
      LinkCategory.dashboard => l10n.linkDashboard,
      LinkCategory.website => l10n.linkWebsite,
      LinkCategory.store => l10n.linkStore,
      LinkCategory.other => l10n.linkOther,
    };

String cycleLabel(AppLocalizations l10n, BillingCycle c) => switch (c) {
      BillingCycle.monthly => l10n.cycleMonthly,
      BillingCycle.yearly => l10n.cycleYearly,
      BillingCycle.lifetime => l10n.cycleLifetime,
      BillingCycle.custom => l10n.cycleCustom,
    };

String subStatusLabel(AppLocalizations l10n, SubStatus s) => switch (s) {
      SubStatus.active => l10n.subActive,
      SubStatus.cancelled => l10n.subCancelled,
      SubStatus.expired => l10n.subExpired,
    };

String themeName(AppLocalizations l10n, AppTheme t) => switch (t) {
      AppTheme.programmerBlue => l10n.theme1,
      AppTheme.terminalGreen => l10n.theme2,
      AppTheme.neonPurple => l10n.theme3,
      AppTheme.sunsetOrange => l10n.theme4,
      AppTheme.nightCrimson => l10n.theme5,
      AppTheme.oceanTeal => l10n.theme6,
      AppTheme.metalSilver => l10n.theme7,
      AppTheme.midnightGold => l10n.theme8,
    };

// ── Shared dialogs & widgets ──────────────────────────────────────────
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  bool destructive = false,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error)
              : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Trial/purchase gate (D-015): blocks create/edit after the 30-day trial
/// ends and routes to the paywall. Returns true when editing is allowed.
class PaywallGate {
  static Future<bool> ensure(BuildContext context, WidgetRef ref) async {
    final canEdit = ref.read(trialProvider).value?.canEdit ?? true;
    if (canEdit) return true;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PaywallScreen()),
    );
    return ref.read(trialProvider).value?.canEdit ?? false;
  }
}

/// Inline error snackbar helper.
void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
