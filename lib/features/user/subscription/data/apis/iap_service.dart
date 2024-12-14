
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/firebase_analytics/firebase_analytics.dart';
import 'package:opclo/routes/route_manager.dart';

import '../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../core/constants/subcription_constants.dart';
import '../../../../../models/user_model.dart';
import '../../controllers/subscription_notifier_ctr.dart';

class IAPService {
  String uid;
  UserModel userModel;
  WidgetRef ref;
  IAPService(this.uid,this.userModel,this.ref);

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList,BuildContext context,WidgetRef ref) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print("purchaseDetails.status ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
         await _handleSuccessfulPurchase(purchaseDetails);
         if(ref.read(subscriptionNotifierCtr).isSubscriptionTapped){
           ref.read(subscriptionNotifierCtr).setSubscriptionTap(isSubsTapped: false);
           AnalyticsHelper.logSubscriptionConversion(productId: purchaseDetails.productID);
           Navigator.pushNamed(context, AppRoutes.conformationScreen);

         }
        }
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        print(purchaseDetails.error!);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print("Purchase marked complete");
      }
    });
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == SubscriptionConstants.opcloMonthly) {
      print("Opclo Monthly Awailed");
      UserModel updatedUserModel =  userModel.copyWith(
        subscriptionAdded: DateTime.now(),
        subscriptionApproved: true,
        subscriptionExpire: DateTime.now().add(Duration(days: 30)),
        subscriptionIsValid: true,
        subscriptionId: SubscriptionConstants.opcloMonthly,
        subscriptionName: SubscriptionConstants.opcloMonthlyName
      );
     await  ref.read(authControllerProvider.notifier).updateSubscriptionInfo(userModel: updatedUserModel, ref: ref);
    }
    if ( purchaseDetails.productID == SubscriptionConstants.opcloYearly) {
      print("Opclo yearly Awailed");
      UserModel updatedUserModel =  userModel.copyWith(
          subscriptionAdded: DateTime.now(),
          subscriptionApproved: true,
          subscriptionExpire: DateTime.now().add(Duration(days: 365)),
          subscriptionIsValid: true,
          subscriptionId: SubscriptionConstants.opcloYearly,
          subscriptionName: SubscriptionConstants.opcloYearlyName
      );
      await  ref.read(authControllerProvider.notifier).updateSubscriptionInfo(userModel: updatedUserModel, ref: ref);
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    print("Verifying Purchase");
    final verifier = FirebaseFunctions.instance.httpsCallable('verifyPurchase');
    final results = await verifier({
      'source': purchaseDetails.verificationData.source,
      'verificationData': purchaseDetails.verificationData.serverVerificationData,
      'productId': purchaseDetails.productID,
    });
    print("Called verify purchase with following result ${results.data}");
    return results.data as bool;
  }

}