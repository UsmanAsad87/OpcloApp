import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';

class ReminderButton extends StatelessWidget {
  final pastButton;
  final upComingButton;
  final bool isPast;

  const ReminderButton(
      {Key? key,
        required this.upComingButton,
        required this.pastButton,
        required this.isPast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
          color: context.primaryColor.withOpacity(.15),
          borderRadius: BorderRadius.circular(6.r)),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: upComingButton,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                      color: isPast
                          ? context.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r)),
                  child: Center(
                      child: Text(
                        'Upcoming',
                        style: getSemiBoldStyle(
                            color: isPast
                                ? context.whiteColor
                                : context.primaryColor,
                            fontSize: MyFonts.size13),
                      ))),
            ),
          ),
          Expanded(
            child: InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: pastButton,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                      color: !isPast
                          ? context.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r)),
                  child: Center(
                      child: Text(
                        'Past',
                        style: getSemiBoldStyle(
                          color: !isPast
                              ? context.whiteColor
                              : context.primaryColor,
                          fontSize: MyFonts.size13,
                        ),
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
