import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openAppInStore() async {
  final String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.opclollc.opclo';
  final String appStoreUrl = 'https://apps.apple.com/app/id6476818278';

  if (defaultTargetPlatform == TargetPlatform.android) {

    if (await canLaunch(playStoreUrl)) {
      await launch(playStoreUrl);
      // SharedPrefHelper.setReviewDone(true);
    } else {
      debugPrint('Could not open the Google Play Store');
    }
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    // Open app in Apple App Store for iOS
    if (await canLaunch(appStoreUrl)) {
      await launch(appStoreUrl);
      // SharedPrefHelper.setReviewDone(true);
    } else {
      debugPrint('Could not open the Apple App Store');
    }
  } else {
    debugPrint('Unsupported platform');
  }
}


Future<void> requestReview() async {
  final InAppReview inAppReview = InAppReview.instance;

  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
  } else {
    // Alternatively, open the app store page directly:
    inAppReview.openStoreListing(
      appStoreId: '6476818278', // Replace with your App Store ID
    );
  }
}