import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:opclo/models/coupon_model.dart';

import '../core/constants/subcription_constants.dart';
import '../models/user_model.dart';

class AnalyticsHelper {
  static FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Log a screen view event
  static Future<void> logScreenView({required String screenName}) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName, // Using screenName as the screen class as well
    );
  }

  // Log app install (automatically tracked, no manual tracking required)
  static Future<void> logAppInstall() async {
    // Firebase automatically tracks app installs, no need for a specific method.
  }

  // Log first open (automatically tracked, no manual tracking required)
  static Future<void> logFirstOpen() async {
    // Firebase automatically tracks first app open, no need for a specific method.
  }

  // Example of tracking other custom events (extend this as needed)
  static Future<void> logEvent({required String eventName, Map<String, dynamic>? parameters}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }
  // Method to log the coupon_viewed event
  static Future<void> logCouponViewed({required CouponModel couponModel}) async {
    await _analytics.logScreenView(
      screenName: "Coupon-Detail",
      screenClass: "Coupon",
    );
    await _analytics.logEvent(
      name: 'coupon_viewed',
      parameters: {
        'coupon_id': couponModel.id,
        'coupon_name': couponModel.title,
        'coupon_category': couponModel.couponCategory.name,
      },
    );
  }
  // Method to log the coupon_redeemed event
  static Future<void> logCouponRedeemed({
  required CouponModel couponModel
  }) async {
    await _analytics.logEvent(
      name: 'coupon_redeemed',
      parameters: {
        'coupon_id': couponModel.id,
        'coupon_name': couponModel.title,
        'redemption_method': couponModel.type.type,
      },
    );
  }

  // Method to log the user_signup event
  static Future<void> logUserSignup({required UserModel user}) async {
    await _analytics.logScreenView(
      screenName: "user-signup",
      screenClass: "Authentication",
    );
    await _analytics.logEvent(
      name: 'user_signup',
      parameters: {
        'signup_method': user.signupTypeEnum.type,
      },
    );
  }

  // Method to log the subscription_conversion event
  static Future<void> logSubscriptionConversion({required String productId}) async {
    String  subscriptionType = productId == SubscriptionConstants.opcloMonthly ?"Monthly":"Yearly";
    await _analytics.logEvent(
      name: 'subscription_conversion',
      parameters: {
        'subscription_type':  subscriptionType,
      },
    );
  }

  // Method to log the alert_viewed event
  static Future<void> logAlertViewed({
    required String alertType,
    required String locationName, // Optional parameter
    required String fsqId

  }) async {
    await _analytics.logScreenView(
      screenName: "alerts_screen",
      screenClass: "Alerts",
    );
    await _analytics.logEvent(
      name: 'alert_viewed',
      parameters: {
        'alert_type': alertType,
        'location_name': locationName,
        'location_fsqId' :fsqId,
      },
    );
  }
}
