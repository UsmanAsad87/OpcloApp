import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/subscription/widgets/subscription_points.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';

class FeaturesAndRating extends StatelessWidget {
  const FeaturesAndRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.r),
                child: const Column(
                  children: [
                    SubscriptionPoints(
                        title: 'Daily Coupon & Savings',
                        desc:
                        'Receive daily in-store and online coupons from places like Sephora, Starbucks, Best Buy, Wendy\'s, and more!'),
                    SubscriptionPoints(
                        title: 'Ad Free', desc: 'Enjoy Opclo ad free.'),
                    SubscriptionPoints(
                        title: 'Support Development',
                        desc:
                        'We plan to operate without undue influence by an outside entity of person that may have an ownership or financial interest in the management responsibilities of Opclo. Your contribution will help us remain truly independent.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(AppConstants.allPadding),
          margin: EdgeInsets.all(AppConstants.allPadding),
          width: double.infinity,
          // height: 300.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [
                MyColors.subContainer1,
                MyColors.subContainer2.withOpacity(.8.r)
                // Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Join a community of ',
                style: getMediumStyle(
                    color: context.whiteColor, fontSize: MyFonts.size14),
              ),
              Text(
                'people who never questions',
                style: getMediumStyle(
                    color: context.whiteColor, fontSize: MyFonts.size14),
              ),
              Text(
                'where to go next',
                style: getMediumStyle(
                    color: context.whiteColor, fontSize: MyFonts.size14),
              ),
              padding16,
              Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.leftWheat,
                        height: 100.h,
                      ),
                      padding32,
                      Image.asset(
                        AppAssets.rightWheat,
                        height: 100.h,
                      )
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '5.0',
                          style: getSemiBoldStyle(
                              color: context.whiteColor,
                              fontSize: MyFonts.size26),
                        ),
                        padding4,
                        SizedBox(
                          width: 55.w,
                          child: Text(
                            'Average rating',
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                                color: context.whiteColor,
                                fontSize: MyFonts.size11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              padding8,
            ],
          ),
        ),
      ],
    );
  }
}