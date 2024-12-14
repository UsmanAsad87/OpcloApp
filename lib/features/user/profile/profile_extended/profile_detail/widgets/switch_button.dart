import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../../utils/thems/my_colors.dart';
import '../../../../../../utils/thems/styles_manager.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({
    super.key,
    required this.onTap,
    required this.value,
  });

  final Function() onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .6,
      child: Container(
        padding: EdgeInsets.all(4.r),
        //width: 30.w,
        decoration: BoxDecoration(color: value ? context.primaryColor : context.bodyTextColor,
            borderRadius: BorderRadius.circular(50.r)
        ),
        child: CupertinoSwitch(
          activeColor: context.primaryColor,
          trackColor: context.bodyTextColor,
          thumbColor: context.whiteColor,
          value: value,
          onChanged: (val) {
            onTap();
          },
        ),
      ),
    );
  }
}
