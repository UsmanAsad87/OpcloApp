import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../utils/constants/app_constants.dart';

class NoPlaceOpen extends StatelessWidget {
  const NoPlaceOpen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.whiteColor,
        leading: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'No Connection',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset(
              AppAssets.noPlaceImage,
            width: 300.w,
            height: 400.h,
          ),
          Padding(
            padding: EdgeInsets.all(AppConstants.allPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'No places Open',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size18),
                ),
                padding8,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    'Sorry, there aren’t any open places in your area at the moment.',
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.3),
                        fontSize: MyFonts.size13),
                  ),
                ),
              ],
            ),
          ),
          CustomButton(onPressed: (){}, buttonText: 'Search again',buttonWidth: 200.w,)
        ],
      ),
    );
  }
}
