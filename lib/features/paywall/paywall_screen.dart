import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import '../../providers/core_providers.dart';
import '../../shared/widgets/common.dart';

/// Paywall (D-014/D-015/D-018): single lifetime IAP, 9.99$ — no keys,
/// no subscriptions. Shown when the 30-day trial expires (or on demand).
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final trial = ref.watch(trialProvider).value;
    final purchaseState = ref.watch(billingProvider);
    final price = ref.read(billingProvider.notifier).price ?? '9.99\$';

    ref.listen(billingProvider, (prev, next) {
      if (next == PurchaseState.purchased) {
        showError(context, l10n.purchaseSuccess);
        ref.read(trialProvider.notifier).refresh();
        Navigator.of(context).pop();
      } else if (next == PurchaseState.notPurchased) {
        showError(context, l10n.purchaseError);
      } else if (next == PurchaseState.pending) {
        showError(context, l10n.purchasePending);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.upgrade)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.workspace_premium,
                  size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                l10n.trialExpiredTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.trialExpiredBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.trialBanner(
                    trial?.daysLeft ?? 0),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: purchaseState == PurchaseState.pending
                    ? null
                    : () => ref.read(billingProvider.notifier).buy(),
                icon: const Icon(Icons.lock_open),
                label: Text(
                  l10n.priceLifetime(price),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () =>
                    ref.read(billingProvider.notifier).restore(),
                icon: const Icon(Icons.restore),
                label: Text(l10n.restorePurchases),
              ),
              const SizedBox(height: 24),
              Text(
                '${AppConstants.appDisplayName} v${AppConstants.appVersion}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
