import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/alert/views/alerts.dart';
import 'package:opclo/features/user/main_menu/controller/main_menu_controller.dart';
import 'package:opclo/features/user/notification/views/coupons.dart';
import 'package:opclo/features/user/notification/views/no_notification_screen.dart';
import 'package:opclo/features/user/notification/views/notifications.dart';
import 'package:opclo/features/user/notification/widgets/notification_and_coupon_button.dart';
import 'package:opclo/utils/constants/app_constants.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool isNotification = true;
  late bool isSignIn;

  @override
  void initState() {
    isSignIn = ref.read(authNotifierCtr).userModel != null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: context.titleColor,
              size: 18.r,
            )),
        backgroundColor: context.whiteColor,
        title: Text(
          'Notification',
          style: getSemiBoldStyle(
            fontSize: MyFonts.size18,
            color: context.titleColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [
            NotificationAndCouponButton(
                couponButton: () {
                  setState(() {
                    isNotification = false;
                  });
                },
                notificationButton: () {
                  setState(() {
                    isNotification = true;
                  });
                },
                isNotification: isNotification
            ),
            isSignIn
                ? isNotification? Notifications(): Coupons()
                : NoNotificationScreen(
                    isCoupon: !isNotification,
                    signInButton: () {
                      ref.read(mainMenuProvider).setIndex(4);
                      Navigator.of(context).pop();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
