import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  // ── Test IDs (replace with real IDs before Play Store upload) ─────
  static const _bannerIdTest       = 'ca-app-pub-3259751381952294/2271752763';
  static const _interstitialIdTest = 'ca-app-pub-3259751381952294/7607839922';
  static const _rewardedIdTest     = 'ca-app-pub-3259751381952294/6374649301';

  static InterstitialAd? _interstitialAd;
  static RewardedAd?     _rewardedAd;
  static BannerAd?       bannerAd;

  static bool _initialized = false;
  static int  _levelsSinceAd = 0;

  // ── Init ────────────────────────────────────────────────────────────
  static Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    _loadInterstitial();
    _loadRewarded();
    loadBanner();
  }

  // ── Banner ──────────────────────────────────────────────────────────
  static void loadBanner() {
    bannerAd = BannerAd(
      adUnitId: _bannerIdTest,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          bannerAd = null;
          debugPrint('Banner ad failed: $error');
        },
      ),
    )..load();
  }

  static Widget? bannerWidget() {
    if (bannerAd == null) return null;
    return SizedBox(
      width: bannerAd!.size.width.toDouble(),
      height: bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: bannerAd!),
    );
  }

  // ── Interstitial ────────────────────────────────────────────────────
  static void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialIdTest,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          debugPrint('Interstitial failed: $error');
        },
      ),
    );
  }

  /// Call after every level completion. Shows ad every 3 levels.
  static void onLevelComplete({VoidCallback? onDismissed}) {
    _levelsSinceAd++;
    if (_levelsSinceAd >= 3) {
      _levelsSinceAd = 0;
      showInterstitial(onDismissed: onDismissed);
    } else {
      onDismissed?.call();
    }
  }

  static void showInterstitial({VoidCallback? onDismissed}) {
    if (_interstitialAd == null) {
      onDismissed?.call();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
        onDismissed?.call();
      },
    );
    _interstitialAd!.show();
  }

  // ── Rewarded ────────────────────────────────────────────────────────
  static void _loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedIdTest,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          debugPrint('Rewarded ad failed: $error');
        },
      ),
    );
  }

  static bool get isRewardedReady => _rewardedAd != null;

  static void showRewarded({required void Function(int coins) onRewarded}) {
    if (_rewardedAd == null) {
      debugPrint('Rewarded ad not ready');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewarded();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) => onRewarded(reward.amount.toInt()),
    );
  }

  // ── Cleanup ─────────────────────────────────────────────────────────
  static void dispose() {
    bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
