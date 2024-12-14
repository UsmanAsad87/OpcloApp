import 'package:flutter/foundation.dart';

String shareAppLink() {
  final String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.opclollc.opclo';
  final String appStoreUrl = 'https://apps.apple.com/app/id6476818278';

  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'error';
    // return playStoreUrl;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return appStoreUrl;
  } else {
    return 'error';
  }
}