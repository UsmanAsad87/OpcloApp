import 'package:flutter/cupertino.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/routes/route_manager.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/font_manager.dart';

class SubscriptionAlertContainer extends StatefulWidget {
  const SubscriptionAlertContainer({Key? key}) : super(key: key);

  @override
  State<SubscriptionAlertContainer> createState() => _SubscriptionAlertContainerState();
}

class _SubscriptionAlertContainerState extends State<SubscriptionAlertContainer> {
  bool hideSub=false;
  @override
  Widget build(BuildContext context) {
    return  hideSub?SizedBox():Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: MyColors.alertContainerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Join Opclo Premium for Exclusive Deals',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size16),
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    hideSub=true;
                  });
                },
                child: Container(
                    margin: EdgeInsets.all(4.r),
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                        color: context.whiteColor,
                        borderRadius: BorderRadius.circular(14.r)),
                    child: const Icon(
                      Icons.close,
                    )),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                'Free for 1 month',
                style: getMediumStyle(
                    color: context.titleColor, fontSize: MyFonts.size14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              '- Exclusive daily coupons & savings',
              style: getRegularStyle(
                  color: context.titleColor.withOpacity(.4.r),
                  fontSize: MyFonts.size11),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              '- Enjoy Opclo ad free',
              style: getRegularStyle(
                  color: context.titleColor.withOpacity(.4.r),
                  fontSize: MyFonts.size11),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              '- Support development',
              style: getRegularStyle(
                  color: context.titleColor.withOpacity(.4.r),
                  fontSize: MyFonts.size11),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              '- More to come!',
              style: getRegularStyle(
                  color: context.titleColor.withOpacity(.4.r),
                  fontSize: MyFonts.size11),
            ),
          ),
          CustomButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.subscriptionScreen);
            },
            buttonWidth: 150.w,
            fontSize: MyFonts.size14,
            buttonText: 'Start for Free!',
          ),
        ],
      ),
    );
  }
}
