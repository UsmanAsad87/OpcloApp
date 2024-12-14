import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/apis_commons.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../main_menu/controller/main_menu_controller.dart';

class ConformationScreen extends StatelessWidget {
  const ConformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.whiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Center(
            child: Text(
          'Confirmation',
          style: getSemiBoldStyle(
            fontSize: MyFonts.size16,
            color: context.titleColor,
          ),
        )),
        actions: [
          Consumer(builder: (context, ref, child) {
            return IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.mainMenuScreen, (route) => false);
                  ref.read(mainMenuProvider).setIndex(0);
                },
                icon: Icon(
                  Icons.close,
                  color: context.primaryColor,
                  weight: 24.r,
                ));
          })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.allPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // padding16,
            Image.asset(
              AppAssets.conformationImage,
              width: 290.w,
              height: 250.h,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Text(
                    'Welcome To Opclo!',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size21),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Text(
                    'Don’t forget to check Opclo everyday to discover places new places.',
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                        fontSize: MyFonts.size13,
                        color: context.titleColor.withOpacity(.5.r)),
                  ),
                ),
              ],
            ),
            Consumer(builder: (context, ref, child) {
              return CustomButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.mainMenuScreen, (route) => false);
                    ref.read(mainMenuProvider).setIndex(0);
                    // Navigator.pushNamed(context, AppRoutes.mainMenuScreen);
                  },
                  buttonText: 'Done');
            })
          ],
        ),
      ),
    );
  }
}
