// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:opclo/commons/common_functions/padding.dart';
// import 'package:opclo/commons/common_widgets/custom_button.dart';
// import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
// import 'package:opclo/core/extensions/color_extension.dart';
// import 'package:opclo/utils/constants/assets_manager.dart';
// import '../../../../commons/common_imports/common_libs.dart';
// import '../../../../utils/constants/font_manager.dart';
//
// class ExpandContainer extends StatefulWidget {
//   const ExpandContainer({
//     super.key,
//     this.initiallyExpanded,
//   });
//
//   final bool? initiallyExpanded;
//
//   @override
//   State<ExpandContainer> createState() => _ExpandContainerState();
// }
//
// class _ExpandContainerState extends State<ExpandContainer> {
//   bool isExpanded = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 0.0.h, vertical: 12.h),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         decoration: BoxDecoration(
//
// //             color: MyColors.notificationColor.withOpacity(.98),
// //             borderRadius: BorderRadius.circular(12.r),
// //             boxShadow: [
// //               BoxShadow(
// //                   spreadRadius: 0,
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 0),
//             color: MyColors.notificationColor.withOpacity(0.95),
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                   spreadRadius: 2,
//                   blurRadius: 2,
//                   offset: const Offset(0, 4),
//
//                   color: context.titleColor.withOpacity(.3))
//             ]),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             padding4,
//             Text(
//               'You are Here',
//               style: getSemiBoldStyle(
//                   fontSize: MyFonts.size15, color: context.whiteColor),
//             ),
//             Text(
//               'Applebee’s Grill + Bar',
//               style: getRegularStyle(
//                   color: context.whiteColor, fontSize: MyFonts.size12),
//             ),
//             SizedBox(height: 2.h,),
//
//             Text(
//               'Open Until 11 : 00 PM',
//               style: getSemiBoldStyle(
//                 color: MyColors.redText,
//                 fontSize: MyFonts.size10,
//               ),
//             ),
//             padding4,
//             if (!isExpanded)
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     isExpanded = !isExpanded;
//                   });
//                 },
//                 child: Column(
//                   children: [
//                     Text(
//                       'swipe Down',
//                       style: getMediumStyle(
//                           color: context.whiteColor, fontSize: MyFonts.size10),
//                     ),
//                     Icon(
//                       Icons.keyboard_arrow_down_sharp,
//                       color: context.whiteColor,
//                     )
//                   ],
//                 ),
//               ),
//             if (isExpanded)
//               Row(
//                 children: [
//                   Expanded(
//                       child: Padding(
//                     padding: EdgeInsets.all(12.r),
//                     child: CustomOutlineButton(
//                       onPressed: () {},
//                       borderRadius: 30.r,
//                       buttonHeight: 40.w,
//                       buttonText: 'Favorite',
//                       fontSize: MyFonts.size11,
//                       textColor: MyColors.themeDarkColor,
//                     ),
//                   )),
//                   Expanded(
//                       child: Padding(
//                     padding: EdgeInsets.all(12.r),
//                     child: CustomButton(
//                         onPressed: () {},
//                         borderRadius: 30.r,
//                         buttonHeight: 40.w,
//                         fontSize: MyFonts.size11,
//                         borderSide:
//                             BorderSide(width: .7, color: context.whiteColor),
//                         backColor: MyColors.notificationColor,
//                         buttonText: 'View Details'),
//                   )),
//                 ],
//               ),
//             if (isExpanded)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//
//                         width: 44.w,
//                         height: 44.h,
//
//                         padding: EdgeInsets.all(11.h),
//                         decoration: BoxDecoration(
//                           color: context.whiteColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: SvgPicture.asset(
//                           AppAssets.alert2,
//                           width: 30.w,
//                           height: 30.h,
//                         ),
//                       ),
//                       SizedBox(width: 11.w,),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Alert!',
//                             style: getSemiBoldStyle(
//                                 color: context.whiteColor,
//                                 fontSize: MyFonts.size15),
//                           ),
//                           Text(
//                             'incorrect hours',
//                             style: getMediumStyle(
//                                 color: context.whiteColor,
//                                 fontSize: MyFonts.size12),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       CustomButton(
//                         onPressed: (){},
//                         buttonText: 'No',
//                         buttonWidth: 67.w,
//                         buttonHeight: 34.h,
//                         borderRadius: 20.r,
//                         backColor: context.whiteColor,
//                         textColor: MyColors.themeDarkColor,
//                         fontSize: MyFonts.size11,
//                       ),
//                       padding4,
//                       Container(
//                         width: 34.w,
//                         height: 34.h,
//                         padding: EdgeInsets.all(4.r),
//                         decoration: BoxDecoration(
//                             color: context.whiteColor, shape: BoxShape.circle),
//                         child: Image.asset(AppAssets.thumbsUpImage, width: 12.w,height: 12.h,),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             padding8,
//             if (isExpanded == true)
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     isExpanded = false;
//                   });
//                 },
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.keyboard_arrow_up_sharp,
//                       color: context.whiteColor,
//                     ),
//                     Text(
//                       'swipe Up to Close',
//                       style: getMediumStyle(
//                           color: context.whiteColor, fontSize: MyFonts.size10),
//                     ),
//                   ],
//                 ),
//               ),
//             padding8,
//           ],
//         ),
//       ),
//     );
//   }
// }
