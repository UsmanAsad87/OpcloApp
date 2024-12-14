import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_providers/shared_pref_helper.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../commons/common_functions/open_app_in_store.dart';
import '../../../../main.dart';
import 'dart:io' show Platform;


class EnjoyFeedback extends StatelessWidget {
  const EnjoyFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedPrefHelper.setReviewDone(true);
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(22.r),
        decoration: BoxDecoration(
          color: context.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.feedbackReviewIcon,
              width: 150.w,
              height: 180.h,
            ),
            padding8,
            Text('Enjoying Oplco?',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size15)),
            padding16,
            Text('Your opinion is important to us.',
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.5),
                    fontSize: MyFonts.size13)),
            Text('We\'d love to know if you\'re enjoying Opclo?',
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.5),
                    fontSize: MyFonts.size13)),
            padding24,
            Container(
              height: 1.5.h,
              width: 260.w,
              color: context.titleColor.withOpacity(.15),
            ),
            SizedBox(
              width: 280.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigatorKey.currentState?.pop();
                        navigatorKey.currentState
                            ?.pushNamed(AppRoutes.feedbackScreen);
                        // Navigator.pushNamed(context, AppAssets.feedback);
                      },
                      child: Column(
                        children: [
                          padding8,
                          Image.asset(
                            AppAssets.sad1Icon,
                            width: 33.w,
                            height: 33.h,
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          Text(
                            'Could be better',
                            style: getMediumStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //       // Icon(CupertinoIcons.smiley),
                  Container(
                    height: 100.h,
                    width: 1.5.w,
                    color: context.titleColor.withOpacity(.15),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigatorKey.currentState?.pop();
                        if(Platform.isIOS){
                          requestReview();
                        }else{
                          openAppInStore();
                        }
                      },
                      child: Column(
                        children: [
                          padding8,
                          Image.asset(
                            AppAssets.loveItIcon,
                            width: 33.w,
                            height: 33.h,
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          Text(
                            'Loving it',
                            style: getMediumStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
