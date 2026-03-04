/*import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PurchaseResult { success, cancelled, failed }

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();
  final InAppPurchase _iap = InAppPurchase.instance;
  final String _productId = 'remove_ads_monthly'; // Subscription ID iOS ='remove_ads_iOS', Subscription ID android = remove_ads_monthly

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final ValueNotifier<bool?> purchaseSuccessNotifier = ValueNotifier(null);
  final Map<String, ProductDetails> _products = {};

  bool get isAvailable => _available;
  bool _available = false;

  // Khởi tạo: gọi từ main()
  Future<void> initialize() async {
    _available = await _iap.isAvailable();
    if (!_available) {
      debugPrint("❌ In-app purchases not available");
      return;
    }

    final response = await _iap.queryProductDetails({_productId});// 🔹 Query sản phẩm
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint("⚠️ Product not found: ${response.notFoundIDs}");
    } else {
      _products[_productId] = response.productDetails.first;
      debugPrint("✅ Loaded product: ${_products[_productId]!.title}");
    }

    await _subscription?.cancel(); // 🔹 Lắng nghe luồng purchase
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (error) => debugPrint("❌ Purchase Stream Error: $error"),
    );
  }

  // ============================================================
  // 🛒 Mua gói remove_ads_monthly
  // ============================================================
  Future<PurchaseResult> purchaseRemoveAds() async {
    if (!_available) {
      debugPrint("⚠️ Store not available yet");
      return PurchaseResult.failed;
    }

    final product = _products[_productId];
    if (product == null) {
      debugPrint("⚠️ Product not loaded yet");
      return PurchaseResult.failed;
    }

    try {
      final param = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: param);// 🔹 Dù là subscription vẫn dùng buyNonConsumable (API thống nhất)
      return PurchaseResult.success;
    } on PlatformException catch (e) {
      if (e.code == 'userCancelled') {
        debugPrint("ℹ️ User cancelled the purchase");
        return PurchaseResult.cancelled;
      } else {
        debugPrint("⚠️ PlatformException: ${e.code} - ${e.message}");
        return PurchaseResult.failed;
      }
    } catch (e) {
      debugPrint("❌ Purchase error: $e");
      return PurchaseResult.failed;
    }
  }

  // ============================================================
  // ♻️ Restore Purchases
  // ============================================================
  Future<void> restorePurchase() async {
    try {
      await _iap.restorePurchases();
      debugPrint("✅ Restore purchases called");
    } catch (e) {
      debugPrint("❌ Restore error: $e");
    }
  }

  // ============================================================
  // 🧾 Lắng nghe khi mua thành công
  // ============================================================
  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _handleSuccess(purchase);
          break;
        case PurchaseStatus.error:
          debugPrint("❌ Purchase error: ${purchase.error}");
          break;
        case PurchaseStatus.pending:
          debugPrint("🕓 Purchase pending...");
          break;
        default:
          break;
      }
    }
  }

  // ============================================================
  // 🎉 Lưu trạng thái khi mua thành công
  // ============================================================
  Future<void> _handleSuccess(PurchaseDetails purchase) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adsRemoved', true);
    await prefs.setString('purchaseDate', DateTime.now().toIso8601String());

    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }

    purchaseSuccessNotifier.value = true;
    debugPrint("✅ Purchase completed: ${purchase.productID}");
  }

  // ============================================================
  // 🔍 Kiểm tra trạng thái đã mua
  // ============================================================
  Future<bool> isAdsRemoved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('adsRemoved') ?? false;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
*/