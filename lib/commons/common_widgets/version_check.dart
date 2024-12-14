import 'package:flutter_svg/svg.dart';
import 'package:opclo/commons/common_functions/bottom_sheet_component.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:version_check/version_check.dart';
import '../../utils/constants/assets_manager.dart';
import '../common_functions/button_component.dart';




class VersionCheckClass {

  final versionCheck = VersionCheck(
    packageName: 'com.opclollc.opclo',
    // packageVersion: '2.0.2',
    showUpdateDialog: (context, versionCheck) {},
  );

  Future checkVersion({required BuildContext context}) async {
    await versionCheck.checkVersion(context);
    // debugPrint(versionCheck.packageVersion);
    // debugPrint(versionCheck.packageName);
    // debugPrint(versionCheck.storeVersion);
    // debugPrint(versionCheck.storeUrl);
    if(versionCheck.storeVersion==null){
      return;
    }
    if (versionCheck.packageVersion!.compareTo(versionCheck.storeVersion!) <
        0) {
      Future.delayed(
        Duration.zero,
        () => bottomSheetComponent(
          context,
          isDismissible: false,
          Column(
            children: [
              Text(
                'A new version of app is available, kindly update your app first before proceeding!',
                style: getBoldStyle(
                    fontSize: 17.spMin, color: MyColors.darkLightTextColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              SvgPicture.asset(
                AppAssets.updateAppSvg,
                height: 84.h,
                width: 84.w,
                color: MyColors.lightThemeColor,
              ),
              SizedBox(height: 25.h),
              ButtonComponent(
                text: 'Update Now',
                onPressed: () => versionCheck.launchStore(),
              )
            ],
          ),
        ),
      );
    }
  }
}
