import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_providers/shared_pref_helper.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../commons/common_imports/common_libs.dart';
import '../../../routes/route_manager.dart';
import '../../../utils/constants/assets_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? prefList;

  initialize() async {
    prefList = await SharedPrefHelper.getPreferences();
  }

  @override
  void initState() {
    initialize();

    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushNamedAndRemoveUntil(
            context,
            prefList == null
                ? AppRoutes.onboardScreen1
                : AppRoutes.mainMenuScreen,
            (route) => false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    //bool isDarkTheme = brightnessValue == Brightness.dark;
    return Scaffold(
        // backgroundColor: context.primaryColor,
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.splashScreenIcon,
              height: 100.h,
              width: 100.w,
            ),
            padding24,
            SvgPicture.asset(
              AppAssets.nameLogo,
              height: 60.h,
              width: 100.w,
            )
          ],
        ),
      ),
    ));
  }
}
