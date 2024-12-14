import 'package:location/location.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/onboard/widgets/brands_circle.dart';
import 'package:opclo/features/onboard/widgets/icon_text_row.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../../../commons/common_imports/common_libs.dart';

class OnboardScreen1 extends StatelessWidget {
  OnboardScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.allPadding),
                    child: Text(
                      'step 1 of 3',
                      style: getBoldStyle(
                          color: context.titleColor.withOpacity(.3),
                          fontSize: MyFonts.size12),
                    ),
                  ),
                ),
              ],
            ),
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
                  BrandCircle(imagePath: AppAssets.wholesFoods, left: 110.w),
                  BrandCircle(
                    imagePath: AppAssets.starBucks,
                    left: 185.w,
                    top: 35.h,
                  ),
                ],
              ),
            ),
            padding40,
            Padding(
              padding: EdgeInsets.all(AppConstants.allPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Discover nearby places',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size23),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Text(
                      'Please enable location services to find places near you.',
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                          color: context.titleColor.withOpacity(.3),
                          fontSize: MyFonts.size13),
                    ),
                  ),
                ],
              ),
            ),
            padding16,
            const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconTextRow(text: 'View real time alerts'),
                  IconTextRow(text: 'Set reminders to visit later'),
                  IconTextRow(text: 'Take notes while on the go'),
                ],
              ),
            ),
            padding24,
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: CustomButton(
                        onPressed: () {
                          requestLocation(context);
                        },
                        buttonText: 'Not Now'),
                  )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: CustomOutlineButton(
                        onPressed: () {
                          requestLocation(context);
                        },
                        buttonText: 'Enable location'),
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  requestLocation(context) async {
    Location location = new Location();
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      Navigator.pushNamed(context, AppRoutes.onboardScreen2);
      // if (_permissionGranted != PermissionStatus.granted) {
      //   // return null;
      // }
    }
    else{
      Navigator.pushNamed(context, AppRoutes.onboardScreen2);
    }
    // await Permission.location.request().then(
    //         (value) => Navigator.pushNamed(context, AppRoutes.onboardScreen2));
  }
}
