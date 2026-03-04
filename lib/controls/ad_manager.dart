/*import 'package:blockbash/controls/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'adhelper.dart';

class AdManager extends ChangeNotifier {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;
  AdWidget? _bannerAdWidget;

  bool _isInterstitialLoaded = false;
  bool _isRewardedLoaded = false;
  bool adsRemoved = false;

  AdWidget? get bannerAdWidget => adsRemoved ? null : _bannerAdWidget;

  // ================= INIT =================
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    adsRemoved = prefs.getBool('adsRemoved') ?? false;

    if (!adsRemoved) {
      loadInterstitialAd();
      loadRewardedAd();
      loadBannerAd();
    }
  }

  /// Gọi sau khi PurchaseService đã khởi tạo
  void initializePurchaseListener(PurchaseService purchaseService) {
    purchaseService.purchaseSuccessNotifier.addListener(() async {
      if (purchaseService.purchaseSuccessNotifier.value == true) {
        adsRemoved = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('adsRemoved', true);
        debugPrint("🔁 AdManager: adsRemoved = true (listener triggered)");

        _bannerAd?.dispose();
        _bannerAd = null;
        _bannerAdWidget = null;
        notifyListeners();

        // Reset notifier
        purchaseService.purchaseSuccessNotifier.value = null;
      }
    });
  }

  // ================= Banner =================
  void loadBannerAd() {
    if (adsRemoved) return;

    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner ad loaded");
          _bannerAdWidget = AdWidget(ad: ad as BannerAd);
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Banner ad failed: $error");
          ad.dispose();
          _bannerAd = null;
          _bannerAdWidget = null;
          Future.delayed(const Duration(seconds: 30), () {
            if (!adsRemoved) loadBannerAd();
          });
        },
      ),
    )..load();
  }

  BannerAd? get bannerAd => adsRemoved ? null : _bannerAd;

  void removeAds() {
    adsRemoved = true;
    _bannerAd?.dispose();
    _bannerAd = null;
    _bannerAdWidget = null;
    notifyListeners();
  }

  // ================= Interstitial =================
  void loadInterstitialAd() {
    if (adsRemoved || _isInterstitialLoaded) return;
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
          debugPrint('✅ Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Failed to load InterstitialAd: $error');
          _isInterstitialLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (adsRemoved) {
      onAdClosed?.call();
      return;
    }

    if (_interstitialAd != null && _isInterstitialLoaded) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialLoaded = false;
          _interstitialAd = null;
          onAdClosed?.call();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _isInterstitialLoaded = false;
    } else {
      onAdClosed?.call();
      loadInterstitialAd();
    }
  }

  // ================= Rewarded =================
  void loadRewardedAd() {
    if (adsRemoved || _isRewardedLoaded) return;

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoaded = true;
          debugPrint("✅ Rewarded ad loaded");
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Failed to load RewardedAd: $error');
          _isRewardedLoaded = false;
        },
      ),
    );
  }

  void showRewardedAd({
    required VoidCallback onEarnedReward,
    VoidCallback? onAdClosed,
  }) {
    if (adsRemoved) {
      onEarnedReward();
      onAdClosed?.call();
      return;
    }

    if (_rewardedAd != null && _isRewardedLoaded) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => onEarnedReward(),
      );
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          _isRewardedLoaded = false;
          onAdClosed?.call();
          loadRewardedAd();
        },
      );
      _isRewardedLoaded = false;
    } else {
      onAdClosed?.call();
      loadRewardedAd();
    }
  }
}
*/
