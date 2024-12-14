import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';

class NoConnection extends StatelessWidget {
  final Function() onTap;
  final bool isPop;
  const NoConnection({Key? key, required this.onTap, this.isPop = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.whiteColor,
        leading: isPop ?  InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ) : null,
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
            AppAssets.noConnectionImage,
            width: 300.w,
            height: 400.h,
          ),
          Padding(
            padding: EdgeInsets.all(AppConstants.allPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'No Connection',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size18),
                ),
                padding8,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    'Whoops! No internet connection found. Please check your connection and try again.',
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.3),
                        fontSize: MyFonts.size13),
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            onPressed: onTap,
            buttonText: 'Try again',
            buttonWidth: 200.w,
          )
        ],
      ),
    );
  }
}
