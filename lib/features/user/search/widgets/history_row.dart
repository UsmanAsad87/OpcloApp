import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class HistoryRow extends StatelessWidget {
  final String title;
  const HistoryRow({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: (){
        Navigator.pushNamed(
            context, AppRoutes.searchResultScreen,
            arguments: {'query': title});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            padding32,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: getMediumStyle(
                        color: context.titleColor,
                        fontSize: MyFonts.size14
                    )),
                // Text('4100 N.W,Crain highway,',
                //     style: getRegularStyle(
                //         color: context.titleColor.withOpacity(.4.r),
                //         fontSize: MyFonts.size13
                //     )),
                // Text('Bowie',
                //     style: getRegularStyle(
                //         color: context.titleColor.withOpacity(.4.r),
                //         fontSize: MyFonts.size13
                //     )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
