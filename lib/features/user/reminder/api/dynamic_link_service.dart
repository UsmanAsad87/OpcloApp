import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/reminder/controller/reminder_controller.dart';
import 'package:opclo/features/user/restaurant/controller/places_controller.dart';
import 'package:opclo/models/crousel_model.dart';
import 'package:opclo/models/reminder_model.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../main.dart';
import '../../../../models/coupon_model.dart';
import '../../../../models/place_model.dart';
import '../widgets/accept_reminder_dailog.dart';

class DynamicLinkService {
  static final String uriPrefix = "https://opclobeta.page.link";
  static final String packageName = "com.opclollc.opclo";
  static final String bundleId = "com.opclollc.opclo";
  static final String appStoreId = "6476818278";

  static Future<String> buildDynamicLinkForReminder(
    bool short,
    String reminderId,
  ) async {
    String linkMessage;
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("$uriPrefix/reminder?reminderId=$reminderId"),
      uriPrefix: uriPrefix,
      androidParameters: AndroidParameters(
        packageName: packageName,
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: bundleId,
        appStoreId: appStoreId,
        minimumVersion: "0.0.0",
      ),
    );

    Uri url;
    final FirebaseDynamicLinks firebaseDynamicLinks =
        FirebaseDynamicLinks.instance;
    if (short) {
      final ShortDynamicLink shortLink =
          await firebaseDynamicLinks.buildShortLink(dynamicLinkParams);
      url = shortLink.shortUrl;
    } else {
      url = await firebaseDynamicLinks.buildLink(dynamicLinkParams);
    }

    linkMessage = url.toString();
    return linkMessage;
  }

  static Future<String> buildDynamicLinkForPlace(
    bool short,
    PlaceModel placeModel,
  ) async {
    String linkMessage;
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "$uriPrefix/place?placeModel=${jsonEncode(placeModel.toJson())}"),
      uriPrefix: uriPrefix,
      androidParameters: AndroidParameters(
        packageName: packageName,
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: bundleId,
        appStoreId: appStoreId,
        minimumVersion: "0.0.0",
      ),
    );

    Uri url;
    final FirebaseDynamicLinks firebaseDynamicLinks =
        FirebaseDynamicLinks.instance;
    if (short) {
      final ShortDynamicLink shortLink =
          await firebaseDynamicLinks.buildShortLink(dynamicLinkParams);
      url = shortLink.shortUrl;
    } else {
      url = await firebaseDynamicLinks.buildLink(dynamicLinkParams);
    }
    linkMessage = url.toString();
    Share.share(linkMessage);
    return linkMessage;
  }

  static Future<String> buildDynamicLinkForBanner(
    bool short,
    CarouselModel carouselModel,
  ) async {

    String linkMessage;
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "$uriPrefix/carousel?carouselModel=${jsonEncode(carouselModel.copyWith(image: '').toMap())}"),
      uriPrefix: uriPrefix,
      androidParameters: AndroidParameters(
        packageName: packageName,
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: bundleId,
        appStoreId: appStoreId,
        minimumVersion: "0.0.0",
      ),
    );

    Uri url;
    final FirebaseDynamicLinks firebaseDynamicLinks =
        FirebaseDynamicLinks.instance;
    if (short) {
      final ShortDynamicLink shortLink =
          await firebaseDynamicLinks.buildShortLink(dynamicLinkParams);
      url = shortLink.shortUrl;
    } else {
      url = await firebaseDynamicLinks.buildLink(dynamicLinkParams);
    }
    linkMessage = url.toString();
    Share.share(linkMessage);
    return linkMessage;
  }

  static Future<String> buildDynamicLinkForCoupon(
    bool short,
    CouponModel couponModel,
  ) async {
    String linkMessage;
    final couponLogo = Uri.encodeFull(couponModel.logo);
    final coupon = jsonEncode(couponModel.copyWith(logo: couponLogo).toMap());
    final encode = Uri.encodeComponent(coupon);
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "$uriPrefix/coupon?couponModel=${encode}"),
      uriPrefix: uriPrefix,
      androidParameters: AndroidParameters(
        packageName: packageName,
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: bundleId,
        appStoreId: appStoreId,
        minimumVersion: "0.0.0",
      ),
    );

    Uri url;
    final FirebaseDynamicLinks firebaseDynamicLinks =
        FirebaseDynamicLinks.instance;
    if (short) {
      final ShortDynamicLink shortLink =
          await firebaseDynamicLinks.buildShortLink(dynamicLinkParams);
      url = shortLink.shortUrl;
    } else {
      url = await firebaseDynamicLinks.buildLink(dynamicLinkParams);
    }
    linkMessage = url.toString();
    Share.share(linkMessage);
    return linkMessage;
  }

  static initDynamicLink(BuildContext context, WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 5));
// if app is running
    FirebaseDynamicLinks.instance.onLink.listen((event) async {
      final Uri deepLink = event.link;
      var isArticle = deepLink.pathSegments.contains('reminder');
      var isPlace = deepLink.pathSegments.contains('place');
      var isCarousel = deepLink.pathSegments.contains('carousel');
      var isCoupon = deepLink.pathSegments.contains('coupon');
      if (isArticle) {
        String? id = deepLink.queryParameters['reminderId'];
        ReminderModel model = await ref
            .read(reminderControllerProvider.notifier)
            .getReminderById(reminderId: id!)
            .first;
        String? userId = ref.read(authNotifierCtr).userModel?.uid;
        if (userId == model.userId) {
          return;
        }
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (_) {
            return AcceptReminderDialog(
              reminderModel: model,
            );
          },
        );
        // navigatorKey.currentState?.pushNamed(AppRoutes.acceptReminderScreen,
        //     arguments: {'reminderModel': model});
      }
      if (isPlace) {
        String placeModelString = deepLink.queryParameters['placeModel']!;
        Map<String, dynamic> jsonMap = jsonDecode(placeModelString);
        navigatorKey.currentState?.pushNamed(AppRoutes.detailResturantScreen,
            arguments: {'placeModel': PlaceModel.fromModelJson(jsonMap)});
      }
      if (isCarousel) {
        String carouselModelString = deepLink.queryParameters['carouselModel']!;
        Map<String, dynamic> jsonMap = jsonDecode(carouselModelString);
        navigatorKey.currentState?.pushNamed(AppRoutes.articles,
            arguments: {'model': CarouselModel.fromMap(jsonMap)});
      }
      if (isCoupon) {
        try {
          String couponModelString = deepLink.queryParameters['couponModel']!;
          String decodedUrl = Uri.decodeComponent(couponModelString);
          Map<String, dynamic> jsonMap = jsonDecode(decodedUrl);
          final couponModel = CouponModel.fromMap(jsonMap);
          final couponLogo = Uri.decodeFull(couponModel.logo);
          navigatorKey.currentState?.pushNamed(AppRoutes.couponsDetailScreen,
              arguments: {
                'couponModel': couponModel.copyWith(logo: couponLogo)
              });
        } catch (e) {
          debugPrint('Error during decoding: $e');
        }
      }
    }).onError((error) {
      showToast(msg: "Error opening link");
    });

//if app is not running
    FirebaseDynamicLinks.instance;
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (data != null) {
      final Uri deepLink = data.link;
      var isArticle = deepLink.pathSegments.contains('reminder');
      var isPlace = deepLink.pathSegments.contains('place');
      var isCarousel = deepLink.pathSegments.contains('carousel');
      var isCoupon = deepLink.pathSegments.contains('coupon');

      if (isArticle) {
        String? id = deepLink.queryParameters['reminderId'];
        ReminderModel model = await ref
            .read(reminderControllerProvider.notifier)
            .getReminderById(reminderId: id!)
            .first;
        String? userId = ref.read(authNotifierCtr).userModel?.uid;
        if (userId == model.userId) {
          return;
        }
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (_) {
            return AcceptReminderDialog(
              reminderModel: model,
            );
          },
        );
      }

      if (isPlace) {
        String placeModelString = deepLink.queryParameters['placeModel']!;
        Map<String, dynamic> jsonMap = jsonDecode(placeModelString);
        navigatorKey.currentState?.pushNamed(AppRoutes.detailResturantScreen,
            arguments: {'placeModel': PlaceModel.fromModelJson(jsonMap)});
      }

      if (isCarousel) {
        String carouselModelString = deepLink.queryParameters['carouselModel']!;
        Map<String, dynamic> jsonMap = jsonDecode(carouselModelString);
        navigatorKey.currentState?.pushNamed(AppRoutes.articles,
            arguments: {'model': CarouselModel.fromMap(jsonMap)});
      }
      if (isCoupon) {
        try {
          String couponModelString = deepLink.queryParameters['couponModel']!;
          String decodedUrl = Uri.decodeComponent(couponModelString);
          Map<String, dynamic> jsonMap = jsonDecode(decodedUrl);
          CouponModel couponModel = CouponModel.fromMap(jsonMap);
          final couponLogo = Uri.decodeFull(couponModel.logo);
          couponModel = couponModel.copyWith(logo: couponLogo);
          navigatorKey.currentState?.pushNamed(AppRoutes.couponsDetailScreen,
              arguments: {
                'couponModel': couponModel.copyWith(logo: couponLogo)
              });
        } catch (e) {
          debugPrint('Error during decoding: $e');
        }
      }
    }
  }
}
