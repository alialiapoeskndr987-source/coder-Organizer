import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import 'trial_service.dart';

/// Google Play Billing — single lifetime IAP (D-014, D-018).
/// Product id: coder_organizer_lifetime (non-consumable, 9.99$ in Play Console).
class BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final TrialService _trial;
  final void Function(PurchaseState state, String? message) onStateChange;

  StreamSubscription<List<PurchaseDetails>>? _sub;
  ProductDetails? _product;

  BillingService(this._trial, {required this.onStateChange});

  String? get currentPrice => _product?.price;

  Future<bool> init() async {
    if (!await _iap.isAvailable()) return false;
    _sub = _iap.purchaseStream.listen(
      _onPurchases,
      onDone: () => _sub?.cancel(),
      onError: (_) {},
    );
    final response = await _iap.queryProductDetails(
      {AppConstants.iapProductId},
    );
    if (response.productDetails.isNotEmpty) {
      _product = response.productDetails.first;
      return true;
    }
    return false;
  }

  Future<void> buy() async {
    final p = _product;
    if (p == null) {
      onStateChange(PurchaseState.notPurchased, null);
      return;
    }
    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: p),
    );
  }

  Future<void> restore() => _iap.restorePurchases();

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID != AppConstants.iapProductId) continue;
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (p.pendingCompletePurchase) await _iap.completePurchase(p);
          await _trial.setPurchased(true);
          onStateChange(PurchaseState.purchased, null);
          break;
        case PurchaseStatus.pending:
          onStateChange(PurchaseState.pending, null);
          break;
        case PurchaseStatus.canceled:
          onStateChange(PurchaseState.notPurchased, null);
          break;
        case PurchaseStatus.error:
          onStateChange(PurchaseState.notPurchased, p.error?.message);
          break;
      }
    }
  }

  void dispose() => _sub?.cancel();
}
