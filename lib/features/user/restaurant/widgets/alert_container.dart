import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';

class AlertContainer extends StatelessWidget {
  final String icon;
  final String title;

  const AlertContainer({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.symmetric(horizontal: AppConstants.padding, vertical: 6.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: context.whiteColor,
          boxShadow: [
            BoxShadow(
              color: context.titleColor.withOpacity(.10),
              blurRadius: 30,
              spreadRadius: 0,
              offset: Offset(0, 10),
            )
          ]),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Image.asset(
              icon,
              width: 28.w,
              height: 28.h,
            ),
          ),
          Text(
            title,
            style: getMediumStyle(
                color: context.titleColor, fontSize: MyFonts.size13),
          ),
        ],
      ),
    );
  }
}
