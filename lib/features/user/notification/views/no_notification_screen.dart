import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_imports/common_libs.dart';

class NoNotificationScreen extends StatelessWidget {
  final Function() signInButton;
  final bool isCoupon;

  const NoNotificationScreen(
      {Key? key, required this.signInButton, required this.isCoupon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32.r),
          child: Image.asset(
            isCoupon ? AppAssets.noCouponsImage : AppAssets.noNotificationImage,
            width: 230.w,
            height: 280.h,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.r),
          child: Text(
            'No ${isCoupon ? "Coupon" : "Notifications"} (yet!)',
            style: getSemiBoldStyle(
                color: context.titleColor, fontSize: MyFonts.size18),
          ),
        ),
        Text(
          !isCoupon
              ? 'Check this section for updates, reminders and genreral Instructions.'
              : "Check this section for daily coupons",
          textAlign: TextAlign.center,
          style: getMediumStyle(
              color: context.titleColor.withOpacity(.5),
              fontSize: MyFonts.size13),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.r),
          child: CustomButton(
              onPressed: signInButton,
              buttonWidth: 200.w,
              buttonHeight: 50.h,
              buttonText: 'Sign in'),
        ),
      ],
    );
  }
}
