import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../onboard/widgets/brands_circle.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.allPadding),
                child: Text(
                  'Share',
                  style: getBoldStyle(
                      color: context.titleColor,
                      fontSize: MyFonts.size16),
                ),
              ),
            ),
            padding40,
            Container(
              width: double.infinity,
              height: 200.h,
              color: Colors.white,
              child: Stack(
                children: [
                  BrandCircle(
                    imagePath: AppAssets.vector,
                    top: 80.h,
                    left: -40.w,
                  ),
                  BrandCircle(
                    imagePath: AppAssets.sevenEleven,
                    bottom: 40.h,
                    right: -30.w,
                  ),
                  BrandCircle(
                    imagePath: AppAssets.chipotle,
                    left: 20.w,
                    top: 10.h,
                  ),
                  BrandCircle(
                    imagePath: AppAssets.mac,
                    bottom: 6.h,
                    right: 70.w,
                  ),
                  BrandCircle(
                    imagePath: AppAssets.brand,
                    top: 5,
                    right: 30.w,
                  ),
                  BrandCircle(
                    imagePath: AppAssets.bestBuy,
                    bottom: 15.h,
                    left: 80.w,
                  ),
                  BrandCircle(
                      imagePath: AppAssets.wholesFoods,
                      left: 110.w
                  ),
                  BrandCircle(
                    imagePath: AppAssets.starBucks,
                    left: 185.w,
                    top: 35.h,
                  ),
                ],
              ),
            ),
            padding64,
            Padding(
              padding: EdgeInsets.all(AppConstants.allPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Go With Opclo',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size21),
                  ),
                  padding8,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Text(
                      'We are constantly updating and improving Opclo for you. However, we need your help to keep it going. Please support our efforts by sharing Opclo with your friends and family. Learn more',
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                          color: context.titleColor.withOpacity(.3.r),
                          fontSize: MyFonts.size13),
                    ),
                  ),
                ],
              ),
            ),
            padding16,
            Padding(
              padding: EdgeInsets.symmetric(vertical : 12.r, horizontal: 24.r),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'https://apps.apple.com/us/app/id14',
                        style: getRegularStyle(
                            color: context.titleColor.withOpacity(.4.r),
                            fontSize: MyFonts.size11),
                      ),
                      Text(
                        'Copy LINK',
                        style: getMediumStyle(
                            color: context.primaryColor, fontSize: MyFonts.size13),
                      )
                    ],
                  ),
                  Divider(
                    color: context.titleColor.withOpacity(.2),
                  ),
                ],
              ),
            ),
            // padding24,
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: CustomButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, AppRoutes.onboardScreen2);
                    },
                    buttonText: 'Share Now'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
