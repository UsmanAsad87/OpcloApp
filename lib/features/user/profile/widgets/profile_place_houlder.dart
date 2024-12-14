import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_functions/padding.dart';

class ProfilePlaceHoulder extends StatelessWidget {
  final Function() onTap;

  const ProfilePlaceHoulder({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: onTap,
              child: Container(
                width: 70.w,
                height: 70.h,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: context.titleColor.withOpacity(.2),
                    ),
                    shape: BoxShape.circle),
                child: Image.asset(AppAssets.addPersonIcon),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              'Account',
              style: getSemiBoldStyle(
                  color: context.titleColor, fontSize: MyFonts.size20),
            ),
            // IconButton(
            //     onPressed: onTap,
            //     icon: Icon(
            //       Icons.login_outlined,
            //       color: context.primaryColor,
            //     ))
          ],
        ),
        padding16,
      ],
    );
  }
}
