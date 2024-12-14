
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32.r),
          child: Image.asset(
            AppAssets.noNotificationImage,
            width: 230.w,
            height: 280.h,
          ),
        ),
        padding16,
        Text(
          'No Notification yet!',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size18),
        ),
        padding8,
        Text(
          'Check this section for updates, reminders and genreral Instructions.',
          textAlign: TextAlign.center,
          style: getMediumStyle(
              color: context.titleColor.withOpacity(.5),
              fontSize: MyFonts.size13),
        ),
      ],
    );
  }
}
