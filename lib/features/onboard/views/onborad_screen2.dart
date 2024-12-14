import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/onboard/widgets/notification_container.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../commons/common_functions/padding.dart';
import '../../../commons/common_imports/common_libs.dart';
import '../../../commons/common_widgets/custom_button.dart';
import '../../../commons/common_widgets/custom_outline_button.dart';
import '../../../firebase_messaging/service/notification_service.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/font_manager.dart';

class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
                  child: Text(
                    'step 2 of 3',
                    style: getBoldStyle(
                        color: context.titleColor.withOpacity(.3),
                        fontSize: MyFonts.size12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Helping You Along the Way',
                      textAlign: TextAlign.center,
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size21),
                    ),
                    Text(
                      'Times are constantly changing. Tap allow when promted about pushed notifications to be notified of all alerts',
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                          color: context.titleColor.withOpacity(.3),
                          fontSize: MyFonts.size13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Center(
                  child: Image.asset(
                AppAssets.device,
                height: 393.h,
                width: 193.w,
              )),
              Center(
                child: Column(
                  children: [
                    padding24,
                    NotificationContainer(
                      title: 'Reminder',
                      subtitle: 'Its time to go to starbucks ',
                      icon: Icons.notifications_active,
                      width: 240.w,
                    ),
                    padding16,
                    NotificationContainer(
                      title: 'Moved Location',
                      subtitle: 'Ben & Jerry’s Ice Cream has moved locations.',
                      icon: Icons.location_on_rounded,
                      width: 284.w,
                    ),
                    padding16,
                    NotificationContainer(
                      title: 'Temporarily Closed',
                      subtitle:
                          'Cheapstake bowling alley is temporarily closed ',
                      icon: Icons.close_rounded,
                      width: 240.w,
                    ),
                    padding16,
                    NotificationContainer(
                      title: 'Attention',
                      subtitle:
                          'Chick Fil a is only taking drive thru orders at this moment.',
                      icon: Icons.info_outline,
                      width: 240.w,
                    ),
                    padding24,
                  ],
                ),
              )
            ],
          ),
          // padding24,
          Container(
            padding: EdgeInsets.all(8.r),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: CustomButton(
                      onPressed: ()  {
                         requestNotification(context);
                        // Navigator.pushNamed(context, AppRoutes.onboardScreen3);
                      },
                      buttonText: 'Not Now'),
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: CustomOutlineButton(
                      onPressed: ()  {
                         requestNotification(context);
                        // Navigator.pushNamed(context, AppRoutes.onboardScreen3);
                      },
                      buttonText: 'Notify Me!'),
                ))
              ],
            ),
          ),
          padding24,
        ],
      ),
    );
  }
  Future<void> saveIsFirstTime(bool isFirstTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', isFirstTime);
  }
  requestNotification(context) async {
    try{
      saveIsFirstTime(false);
      await LocalNotificationService.initializeNew1();

      // await Permission.notification.request().then(
      //         (value) => Navigator.pushNamed(context, AppRoutes.onboardScreen3));

      await Permission.notification.request();
      Navigator.pushNamed(context, AppRoutes.onboardScreen3);
    }catch(e){
      Navigator.pushNamed(context, AppRoutes.onboardScreen3);
    }

  }
}
