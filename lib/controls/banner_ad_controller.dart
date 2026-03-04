/*import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'adhelper.dart';

class BannerAdController {
  BannerAd? _bannerAd;
  final ValueNotifier<BannerAd?> adNotifier = ValueNotifier(null);

  /// Cờ kiểm tra người chơi có mua gói remove ads
  bool adsRemoved = false;

  void loadBannerAd() {
    if (adsRemoved) {
      // Người chơi đã mua gói remove ads
      debugPrint('Ads removed, banner will not load.');
      return;
    }

    // Nếu đã có banner đang load hoặc load xong thì không tạo lại
    if (_bannerAd != null) return;

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId, // nhớ đổi sang ID thật
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner ad loaded");
          adNotifier.value = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Banner ad failed: $error");
          ad.dispose();
          _bannerAd = null;
          adNotifier.value = null;

          // Retry sau 30 giây nếu người chơi chưa remove ads
          Future.delayed(const Duration(seconds: 30), () {
            if (!adsRemoved) loadBannerAd();
          });
        },
      ),
    )..load();
  }

  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    adNotifier.value = null;
    adNotifier.dispose();
  }
}

*/