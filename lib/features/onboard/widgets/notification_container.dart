import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../commons/common_imports/common_libs.dart';

class NotificationContainer extends StatelessWidget {
  final title;
  final subtitle;
  final icon;
  final width;

  const NotificationContainer(
      {Key? key,
        required this.title,
        required this.subtitle,
        required this.icon,
        required this.width
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9.r),
      width: width,
      decoration: BoxDecoration(
          color: context.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
                color: context.titleColor.withOpacity(.3),
                spreadRadius: 0,
                blurRadius: 11,
                offset: const Offset(0,0)

            )
          ]
      ),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(.2),
              borderRadius: BorderRadius.circular(3.r),

            ),
            child: Icon(icon,color: context.primaryColor,size: 15.r,),
          ),
          SizedBox(width: 4.w,),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Container(
                //       padding: EdgeInsets.all(4.r),
                //       decoration: BoxDecoration(
                //         color: context.primaryColor.withOpacity(.2),
                //         borderRadius: BorderRadius.circular(3.r),
                //
                //       ),
                //       child: Icon(icon,color: context.primaryColor,size: 15.r,),
                //     ),
                    // Padding(
                    //   padding:  EdgeInsets.only(left : 8.w),
                    //   child:
                      Text(title,style: getSemiBoldStyle(color: context.titleColor,fontSize: MyFonts.size11),),
                    // )
                //   ],
                // ),
                // Padding(
                //   padding:  EdgeInsets.symmetric(horizontal: 8.w),
                //   child:
                //   Divider(
                //     color: context.titleColor.withOpacity(.2),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  height: 1.h,
                  color: context.titleColor.withOpacity(.2),
                  width: width - 50.w,),
                SizedBox(
                  width: width - 50.w,
                  child: Text(
                    subtitle,
                    style: getMediumStyle(color: context.titleColor.withOpacity(.3),
                        fontSize: MyFonts.size10),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
