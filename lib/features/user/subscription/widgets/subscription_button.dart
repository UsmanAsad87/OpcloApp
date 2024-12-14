import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';

class SubscriptionButton extends StatelessWidget {
  final onTap;
  const SubscriptionButton({Key? key,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // width: double.infinity,
        height: 55.h,
       padding: EdgeInsets.all(4.r),
        // margin: EdgeInsets.s(20.w,4.h,20.w,20.h),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GO UNLIMITED',
                  style: getSemiBoldStyle(color: context.whiteColor,fontSize: MyFonts.size16),
                ),
              ],
            ),
            Text(
              'with a 1-month free trial',
              style: getRegularStyle(color: context.whiteColor,fontSize: MyFonts.size8),
            ),
          ],
        ),
      ),
    );
  }
}
