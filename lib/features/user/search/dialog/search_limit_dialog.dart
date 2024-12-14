import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../subscription/widgets/subscription_button.dart';


class SearchLimitDialog extends StatelessWidget {
  final String description;
  const SearchLimitDialog({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.r),
      height: 400.h,
      decoration: BoxDecoration(
        color: context.whiteColor,
        borderRadius: BorderRadius.circular(30.r)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            padding40,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.limitIcon,
                  width: 150.w,
                  height: 80.h,
                ),
              ],
            ),
            padding24,
            Text(
              'Oops, That’s it!',
              style: getBoldStyle(
                  color: Colors.black, fontSize: MyFonts.size22),
            ),
            padding8,
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                description,
                // 'You\'ve reached your limit for today. More access will be available in 8 hours, 22 minutes. Want unlmited access? Upgrade now!',
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  color: context.bodyTextColor,
                  fontSize: MyFonts.size14
                ),
              ),
            ),
            padding16,
            Material(
              child: SubscriptionButton(onTap: () {
                Navigator.pushNamed(context, AppRoutes.subscriptionScreen);
              }),
            )
          ],
        ),
      ),
    );
  }
}
