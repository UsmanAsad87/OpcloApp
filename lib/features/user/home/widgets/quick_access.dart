//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:opclo/commons/common_imports/common_libs.dart';
// import 'package:opclo/commons/common_providers/shared_pref_helper.dart';
// import 'package:opclo/core/extensions/color_extension.dart';
// import 'package:opclo/features/auth/controller/auth_controller.dart';
// import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
// import 'package:opclo/features/user/home/widgets/place_name_and_location_container.dart';
// import 'package:opclo/features/user/main_menu/controller/main_menu_controller.dart';
// import 'package:opclo/features/user/restaurant/controller/places_controller.dart';
// import 'package:opclo/utils/constants/font_manager.dart';
// import 'package:opclo/utils/loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
// import '../../../../utils/constants/app_constants.dart';
// import '../../profile/profile_extended/add_note/views/add_location.dart';
// import '../controller/sheet_height_controller.dart';
//
// class QuickAccessBottomSheet extends ConsumerStatefulWidget {
//   const QuickAccessBottomSheet({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<QuickAccessBottomSheet> createState() =>
//       _QuickAccessBottomSheetState();
// }
//
// class _QuickAccessBottomSheetState
//     extends ConsumerState<QuickAccessBottomSheet> {
//   void _showSheet(context) {
//     showModalBottomSheet(
//         context: context,
//         enableDrag: true,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (context) {
//           return AddLocation(
//             isQuickAccess: true,
//           );
//         });
//   }
//
//   GlobalKey _one = GlobalKey();
//   GlobalKey _two = GlobalKey();
//   bool showShowcase = true;
//
//   Future<void> _checkShowcasePreference() async {
//     // final prefs = await SharedPreferences.getInstance();
//     // Check if the 'showShowcase' flag exists or is true
//     final result = await SharedPrefHelper.getShowCase();
//     setState(() {
//       showShowcase = result; //prefs.getBool('showShowcase') ?? true;
//     });
//
//     if (showShowcase) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ShowCaseWidget.of(context).startShowCase([_one, _two]);
//       });
//     }
//   }
//
//   Future<void> _setShowcaseVisited() async {
//     final prefs = await SharedPreferences.getInstance();
//     // Set the 'showShowcase' flag to false
//     await prefs.setBool('showShowcase', false);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _checkShowcasePreference();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ShowCaseWidget.of(context).startShowCase([_one, _two]);
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     if (showShowcase) {
//       SharedPrefHelper.setShowcaseVisited(false);
//       return Showcase(
//         key: _one,
//         title: "Quick Access",
//         titleTextStyle: getSemiBoldStyle(
//             color: context.whiteColor, fontSize: MyFonts.size20),
//         showArrow: true,
//         descTextStyle:
//         getMediumStyle(color: context.whiteColor, fontSize: MyFonts.size12),
//         description: 'Quickly access your favorite places from here.',
//         targetShapeBorder: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(100))),
//         child: BuildBottomSheet(context),
//         tooltipBackgroundColor: Colors.transparent,
//         disposeOnTap: true,
//         onTargetClick: () {
//           SharedPrefHelper.setShowcaseVisited(false);
//           ShowCaseWidget.of(context).dismiss();
//         },
//       );
//     }
//     return BuildBottomSheet(context);
//   }
//
//   void handleHeight(dynamic details,double startHeight) {
//     double height =
//     (ref
//         .watch(sheetHeightProvider)
//         .height! - details.primaryDelta!)
//         .clamp(40.h, 700.h);
//     if (ref
//         .watch(sheetHeightProvider)
//         .isClosed) {
//       if (details.primaryDelta! < 0) {
//         ref.watch(sheetHeightProvider.notifier).setHeight(360.h);
//         return;
//       }
//     }
//     if (ref
//         .watch(sheetHeightProvider.notifier)
//         .height == 360.h && ref
//         .watch(sheetHeightProvider)
//         .isClosed) {
//       ref.watch(sheetHeightProvider).setClosed(false);
//       return;
//     }
//
//     if (ref
//         .watch(sheetHeightProvider.notifier)
//         .height == 360.h) {
//       if (details.primaryDelta! < 0) {
//         ref.watch(sheetHeightProvider.notifier).setHeight(700.h);
//         return;
//       }
//     }
//     if (height > 40.h && height < 250.h) {
//       ref.watch(sheetHeightProvider.notifier).setHeight(360.h);
//       return;
//     } else if (height > 250.h && height < 330.h) {
//       ref.watch(sheetHeightProvider.notifier).setHeight(40.h);
//       ref.watch(sheetHeightProvider).setClosed(true);
//     }
//     else if (height > 300.h && height < 500.h) {
//       ref.watch(sheetHeightProvider.notifier).setHeight(700.h);
//     }
//     // else if (height > 500 && height < double.infinity) {
//     //   ref.watch(sheetHeightProvider.notifier).setHeight(360.h);
//     // }
//     else {
//       double newHeight = startHeight - details.primaryDelta!;
//       double clampedHeight = newHeight.clamp(40.h, 700.h);
//
//       if (details.primaryDelta! < 0) {
//
//       } else {
//         // Dragging downwards
//         if (startHeight <= 360.h) {
//           ref.watch(sheetHeightProvider.notifier).setHeight(40.h);
//           ref.watch(sheetHeightProvider).setClosed(true);
//         } else {
//           ref.watch(sheetHeightProvider.notifier).setHeight(360.h);
//         }
//       }
//     }
//   }
//
//   GestureDetector BuildBottomSheet(BuildContext context) {
//     double startHeight = ref.watch(sheetHeightProvider).height!;
//     return GestureDetector(
//       onVerticalDragUpdate: (details) {
//        handleHeight(details,startHeight);
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeIn,
//         padding: EdgeInsets.only(
//           top: 5.h,
//           bottom: 0.h,
//           right: AppConstants.allPadding,
//           left: AppConstants.allPadding,
//         ),
//         height: ref.watch(sheetHeightProvider).height,
//         decoration: BoxDecoration(
//             color: context.whiteColor,
//             boxShadow: [
//                             BoxShadow(
//                               blurRadius: 10,
//                               spreadRadius: 2,
//                               offset: Offset(0, 0),
//                               color: context.titleColor.withOpacity(.5),
//                             ),
//             ],
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25.r),
//                 topRight: Radius.circular(25.r))),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               child: Center(
//                 child: Container(
//                   margin: EdgeInsets.only(
//                     top: 5.h,
//                     bottom: 24.h,
//                     right: AppConstants.allPadding,
//                     left: AppConstants.allPadding,
//                   ),
//                   width: 66.w,
//                   height: 6.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50.r),
//                     color: context.titleColor.withOpacity(.2),
//                   ),
//                 ),
//               ),
//             ),
//              ((ref.watch(sheetHeightProvider).height ?? 0.h) > 100.h)?Expanded(
//                child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(right: 8.w,left: 8.w,bottom: 16.h,top: 6.h),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Quick Access',
//                           style: getSemiBoldStyle(
//                             color: context.titleColor,
//                             fontSize: MyFonts.size18,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             ref.watch(authNotifierCtr).userModel == null
//                                 ? ref.watch(mainMenuProvider).setIndex(4)
//                                 : _showSheet(context);
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(4.r),
//                             decoration: BoxDecoration(
//                               color: context.primaryColor,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.add_outlined,
//                               size: 23.r,
//                               color: context.whiteColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       child: ref.watch(authNotifierCtr).userModel == null
//                           ? Padding(
//                         padding: EdgeInsets.only(top: 12.h),
//                         child: Text(
//                           'Login to add quickAccess',
//                           style: getMediumStyle(
//                               color: context.titleColor,
//                               fontSize: MyFonts.size12),
//                         ),
//                       )
//                           : ref.watch(quickAccessStreamProvider(context)).when(
//                         data: (placesId) {
//                           return ListView.builder(
//                             padding: EdgeInsets.zero,
//                             shrinkWrap: false,
//                             physics: AlwaysScrollableScrollPhysics(),
//                             itemCount: placesId.length,
//                             itemBuilder: (context, index) {
//                               final String placeId = placesId[index];
//                               return ref
//                                   .watch(getPlacesByIdProvider(placeId))
//                                   .when(
//                                   data: (place) {
//                                     return PlaceNameAndLocationContainer(
//                                       title: place!.placeName,
//                                       subTitle: place.locationName,
//                                       place: place,
//                                     );
//                                   },
//                                   error: (error, stack) => SizedBox(),
//                                   loading: () => LoadingWidget());
//                             },
//                           );
//                         },
//                         error: (error, stack) => Text('Loading'),
//                         loading: () => LoadingWidget(),
//                       ),
//                     ),
//                   ),
//                 ],),
//              ):SizedBox()
//
//           ],
//         ),
//       ),
//     );
//   }
//
// // Widget Item(
// //         {required BuildContext context,
// //         required String title,
// //         required String subTitle}) =>
// //     Container(
// //         padding: EdgeInsets.all(12.r),
// //         margin: EdgeInsets.symmetric(vertical: 8.h),
// //         decoration: BoxDecoration(
// //             color: MyColors.white,
// //             borderRadius: BorderRadius.circular(8.r),
// //             boxShadow: [
// //               BoxShadow(
// //                 blurRadius: 20,
// //                 spreadRadius: 0,
// //                 offset: Offset(0, 0),
// //                 color: context.titleColor.withOpacity(.10),
// //               ),
// //             ]),
// //         child: Container(
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     title, //'LA Fitness',
// //                     style: getSemiBoldStyle(
// //                       color: context.titleColor,
// //                       fontSize: MyFonts.size16,
// //                     ),
// //                   ),
// //                   Text(
// //                     subTitle, //'1101 Connecticut Ave NW',
// //                     style: getMediumStyle(
// //                       color: context.titleColor.withOpacity(.5),
// //                       fontSize: MyFonts.size13,
// //                     ),
// //                   )
// //                 ],
// //               ),
// //               Icon(
// //                 Icons.arrow_forward_ios_outlined,
// //                 color: context.titleColor,
// //                 size: 18.r,
// //               )
// //             ],
// //           ),
// //         ));
// }
//
// /*
//
//
//
// class QuickAccessBottomSheet extends ConsumerStatefulWidget {
//   const QuickAccessBottomSheet({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<QuickAccessBottomSheet> createState() =>
//       _QuickAccessBottomSheetState();
// }
//
// class _QuickAccessBottomSheetState
//     extends ConsumerState<QuickAccessBottomSheet> {
//   void _showSheet(context) {
//     showModalBottomSheet(
//         context: context,
//         enableDrag: true,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (context) {
//           return AddLocation(
//             isQuickAccess: true,
//           );
//         });
//   }
//
//   GlobalKey _one = GlobalKey();
//   GlobalKey _two = GlobalKey();
//   bool showShowcase = true;
//
//   Future<void> _checkShowcasePreference() async {
//     final result = await SharedPrefHelper.getShowCase();
//     setState(() {
//       showShowcase = result;
//     });
//
//     if (showShowcase) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ShowCaseWidget.of(context).startShowCase([_one, _two]);
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _checkShowcasePreference();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ShowCaseWidget.of(context).startShowCase([_one, _two]);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (showShowcase) {
//       SharedPrefHelper.setShowcaseVisited(false);
//       return Showcase(
//         key: _one,
//         title: "Quick Access",
//         titleTextStyle: getSemiBoldStyle(
//             color: context.whiteColor, fontSize: MyFonts.size20),
//         showArrow: true,
//         descTextStyle:
//         getMediumStyle(color: context.whiteColor, fontSize: MyFonts.size12),
//         description: 'Quickly access your favorite places from here.',
//         targetShapeBorder: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(100))),
//         child: BuildBottomSheet(context),
//         tooltipBackgroundColor: Colors.transparent,
//         disposeOnTap: true,
//         onTargetClick: () {
//           SharedPrefHelper.setShowcaseVisited(false);
//           ShowCaseWidget.of(context).dismiss();
//         },
//       );
//     }
//     return BuildBottomSheet(context);
//   }
//
//
// //
// //   Widget BuildBottomSheet(BuildContext context) {
// // return  DraggableScrollableSheet(
// // builder: (BuildContext context,
// //   ScrollController scrollController) {
// //   return Container(
// //     height: ref.watch(sheetHeightProvider).height,
// //
// //   decoration: const BoxDecoration(
// //   color: Colors.white,
// //   borderRadius: BorderRadius.only(
// //   topLeft: Radius.circular(20),
// //   topRight: Radius.circular(20),
// //   ),
// //   ),
// //   child: 1==1 ?  Column(
// //   children: [
// //   SingleChildScrollView(
// //   physics: const BouncingScrollPhysics(),
// //   controller: scrollController,
// //   child: Container(
// //   height: 100.h,
// //   width: 375.sw,
// //   alignment: Alignment.center,
// //   child: const Center(
// //   child: Text('No Nearby Offers Found!'),
// //   ),
// //   ),
// //   )
// //   ],
// //   ):
// //   ref.watch(authNotifierCtr).userModel == null
// //       ? Padding(
// //     padding: EdgeInsets.only(top: 12.h),
// //     child: Text(
// //       'Login to add quickAccess',
// //       style: getMediumStyle(
// //           color: context.titleColor,
// //           fontSize: MyFonts.size12),
// //     ),
// //   )
// //       : ref.watch(quickAccessStreamProvider(context)).when(
// //     data: (placesId) {
// //       return placesId.isEmpty
// //           ? ref.watch(sheetHeightProvider).height! == 40.h
// //           ? Container()
// //           : Center(
// //         child: Text(
// //           'No Quick access (yet!)',
// //           style: getMediumStyle(
// //               color: context.titleColor,
// //               fontSize: MyFonts.size12),
// //         ),
// //       )
// //           : Container(
// //         color: MyColors.white,
// //         child: ListView.builder(
// //           shrinkWrap: true,
// //           itemCount: placesId.length,
// //           itemBuilder: (context, index) {
// //             final String placeId =
// //             placesId[index];
// //             return ref
// //                 .watch(getPlacesByIdProvider(
// //                 placeId))
// //                 .when(
// //                 data: (place) {
// //                   return InkWell(
// //                     onTap: () {
// //                       Navigator.pushNamed(
// //                           context,
// //                           AppRoutes
// //                               .detailResturantScreen,
// //                           arguments: {
// //                             'placeModel':
// //                             place
// //                           });
// //                     },
// //                     child:
// //                     PlaceNameAndLocationContainer(
// //                       title: place!.placeName,
// //                       subTitle:
// //                       place.locationName,
// //                     ),
// //                   );
// //                 },
// //                 error: (error, stack) =>
// //                     SizedBox(),
// //                 loading: () =>
// //                     ListView.builder(
// //                         itemCount: 3,
// //                         shrinkWrap: true,
// //                         physics:
// //                         NeverScrollableScrollPhysics(),
// //                         itemBuilder:
// //                             (context, index) {
// //                           return QuickAccessContainerShimmer();
// //                         }));
// //           },
// //         ),
// //       );
// //     },
// //     error: (error, stack) => Text('Loading'),
// //     loading: () => ListView.builder(
// //         itemCount: 3,
// //         shrinkWrap: true,
// //         physics: NeverScrollableScrollPhysics(),
// //         itemBuilder: (context, index) {
// //           return QuickAccessContainerShimmer();
// //         }),
// //   ),
// //   );
// //   },
// //   );
// // }
//   //
//   // DraggableScrollableSheet BuildBottomSheet(BuildContext context) {
//   //   return DraggableScrollableSheet(
//   //     // onVerticalDragUpdate: (details) {
//   //     //   double height =
//   //     //       (ref.watch(sheetHeightProvider).height! - details.primaryDelta!)
//   //     //           .clamp(40.h, double.infinity);
//   //     //   ref.watch(sheetHeightProvider.notifier).setHeight(height);
//   //     // },
//   //     builder: (BuildContext context,
//   //  ScrollController scrollController) {
//   //         return Container(
//   //           //height: ref.watch(sheetHeightProvider).height,
//   //           decoration: BoxDecoration(
//   //             color: context.whiteColor,
//   //             boxShadow: [
//   //               BoxShadow(
//   //                 blurRadius: 10,
//   //                 spreadRadius: 2,
//   //                 offset: Offset(0, 0),
//   //                 color: context.titleColor.withOpacity(.5),
//   //               ),
//   //             ],
//   //             borderRadius: BorderRadius.only(
//   //               topLeft: Radius.circular(25.r),
//   //               topRight: Radius.circular(25.r),
//   //             ),
//   //           ),
//   //           child: Column(
//   //             mainAxisAlignment: MainAxisAlignment.start,
//   //             children: <Widget>[
//   //               InkWell(
//   //                 onTap: () {
//   //                   double height = ref.watch(sheetHeightProvider).height!;
//   //                   height = height == 40.h ? 550.h : 40.h;
//   //                   ref.watch(sheetHeightProvider.notifier).setHeight(height);
//   //                 },
//   //                 child: Container(
//   //                   child: Center(
//   //                     child: Container(
//   //                       margin: EdgeInsets.symmetric(
//   //                         horizontal: AppConstants.allPadding,
//   //                         vertical: 12.h,
//   //                       ),
//   //                       width: 66.w,
//   //                       height: 6.h,
//   //                       decoration: BoxDecoration(
//   //                         borderRadius: BorderRadius.circular(50.r),
//   //                         color: context.titleColor.withOpacity(.2),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //            Container(
//   //                       margin: EdgeInsets.symmetric(
//   //                         horizontal: 11.w,
//   //                       ),
//   //                       padding: EdgeInsets.symmetric(
//   //                           horizontal: 8.w, vertical: 16.h),
//   //                       child: Row(
//   //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                         children: [
//   //                           Text(
//   //                             'Quick Access',
//   //                             style: getSemiBoldStyle(
//   //                               color: context.titleColor,
//   //                               fontSize: MyFonts.size18,
//   //                             ),
//   //                           ),
//   //                           InkWell(
//   //                             onTap: () {
//   //                               ref.watch(authNotifierCtr).userModel == null
//   //                                   ? ref.watch(mainMenuProvider).setIndex(4)
//   //                                   : _showSheet(context);
//   //                             },
//   //                             child: Container(
//   //                               padding: EdgeInsets.all(4.r),
//   //                               decoration: BoxDecoration(
//   //                                 color: context.primaryColor,
//   //                                 shape: BoxShape.circle,
//   //                               ),
//   //                               child: Icon(
//   //                                 Icons.add_outlined,
//   //                                 size: 23.r,
//   //                                 color: context.whiteColor,
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ),
//   //               ref.watch(authNotifierCtr).userModel == null
//   //                   ? Padding(
//   //                       padding: EdgeInsets.only(top: 12.h),
//   //                       child: Text(
//   //                         'Login to add quickAccess',
//   //                         style: getMediumStyle(
//   //                             color: context.titleColor,
//   //                             fontSize: MyFonts.size12),
//   //                       ),
//   //                     )
//   //                   : ref.watch(quickAccessStreamProvider(context)).when(
//   //                         data: (placesId) {
//   //                           return placesId.isEmpty
//   //                               ? ref.watch(sheetHeightProvider).height! == 40.h
//   //                                   ? Container()
//   //                                   : Center(
//   //                                       child: Text(
//   //                                         'No Quick access (yet!)',
//   //                                         style: getMediumStyle(
//   //                                             color: context.titleColor,
//   //                                             fontSize: MyFonts.size12),
//   //                                       ),
//   //                                     )
//   //                               : Container(
//   //                                 color: MyColors.white,
//   //                                 child: ListView.builder(
//   //                                   shrinkWrap: true,
//   //                                   itemCount: placesId.length,
//   //                                   itemBuilder: (context, index) {
//   //                                     final String placeId =
//   //                                         placesId[index];
//   //                                     return ref
//   //                                         .watch(getPlacesByIdProvider(
//   //                                             placeId))
//   //                                         .when(
//   //                                             data: (place) {
//   //                                               return InkWell(
//   //                                                 onTap: () {
//   //                                                   Navigator.pushNamed(
//   //                                                       context,
//   //                                                       AppRoutes
//   //                                                           .detailResturantScreen,
//   //                                                       arguments: {
//   //                                                         'placeModel':
//   //                                                             place
//   //                                                       });
//   //                                                 },
//   //                                                 child:
//   //                                                     PlaceNameAndLocationContainer(
//   //                                                   title: place!.placeName,
//   //                                                   subTitle:
//   //                                                       place.locationName,
//   //                                                 ),
//   //                                               );
//   //                                             },
//   //                                             error: (error, stack) =>
//   //                                                 SizedBox(),
//   //                                             loading: () =>
//   //                                                 ListView.builder(
//   //                                                     itemCount: 3,
//   //                                                     shrinkWrap: true,
//   //                                                     physics:
//   //                                                         NeverScrollableScrollPhysics(),
//   //                                                     itemBuilder:
//   //                                                         (context, index) {
//   //                                                       return QuickAccessContainerShimmer();
//   //                                                     }));
//   //                                   },
//   //                                 ),
//   //                               );
//   //                         },
//   //                         error: (error, stack) => Text('Loading'),
//   //                         loading: () => ListView.builder(
//   //                             itemCount: 3,
//   //                             shrinkWrap: true,
//   //                             physics: NeverScrollableScrollPhysics(),
//   //                             itemBuilder: (context, index) {
//   //                               return QuickAccessContainerShimmer();
//   //                             }),
//   //                       ),
//   //             ],
//   //           ),
//   //         );
//   //       }
//   //     );
//   // }
//
//   GestureDetector BuildBottomSheet(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragUpdate: (details) {
//           double height =
//           (ref.watch(sheetHeightProvider).height! - details.primaryDelta!)
//               .clamp(40.h, double.infinity);
//           print(height);
//         //   if(details.primaryDelta){}
//         // if ((details.primaryDelta ?? 0).abs() > 10) {
//         //   double height = ref.watch(sheetHeightProvider).height!;
//         //   height = height == 40.h ? 550.h : 40.h;
//           ref.watch(sheetHeightProvider.notifier).setHeight(height);
//         // }
//       },
//       // onTap: () {
//       //   double height = ref.watch(sheetHeightProvider).height!;
//       //   height = height == 40.h ? 550.h : 40.h;
//       //   ref.watch(sheetHeightProvider.notifier).setHeight(height);
//       // },
//       child: Container(
//         // padding: EdgeInsets.symmetric(
//         //     horizontal: AppConstants.allPadding, vertical: 12.h),
//         height: ref.watch(sheetHeightProvider).height,
//         decoration: BoxDecoration(
//             color: context.whiteColor,
//             boxShadow: [
//               BoxShadow(
//                 blurRadius: 20,
//                 spreadRadius: 5,
//                 offset: Offset(40, 0),
//                 color: context.titleColor.withOpacity(.5),
//               ),
//             ],
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25.r),
//                 topRight: Radius.circular(25.r))),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Center(
//                 child: InkWell(
//                   onTap: (){
//                       double height = ref.watch(sheetHeightProvider).height!;
//                       height = height == 40.h ? 550.h : 40.h;
//                       ref.watch(sheetHeightProvider.notifier).setHeight(height);
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(
//                         horizontal: AppConstants.allPadding, vertical: 12.h),
//                     width: 66.w,
//                     height: 6.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50.r),
//                       color: context.titleColor.withOpacity(.2),
//                     ),
//                   ),
//                 ),
//               ),
//               ref.watch(sheetHeightProvider).height! == 40.h
//                   ? Container(
//                       height: 9.h,
//                     )
//                   : Container(
//                       margin: EdgeInsets.symmetric(
//                         horizontal: 11.w,
//                       ),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Quick Access',
//                             style: getSemiBoldStyle(
//                               color: context.titleColor,
//                               fontSize: MyFonts.size18,
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               ref.watch(authNotifierCtr).userModel == null
//                                   ? ref.watch(mainMenuProvider).setIndex(4)
//                                   : _showSheet(context);
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(4.r),
//                               decoration: BoxDecoration(
//                                 color: context.primaryColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.add_outlined,
//                                 size: 23.r,
//                                 color: context.whiteColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//               ref.watch(authNotifierCtr).userModel == null
//                   ? Padding(
//                       padding: EdgeInsets.only(top: 12.h),
//                       child: Text(
//                         'Login to add quickAccess',
//                         style: getMediumStyle(
//                             color: context.titleColor, fontSize: MyFonts.size12),
//                       ),
//                     )
//                   : ref.watch(quickAccessStreamProvider(context)).when(
//                         data: (placesId) {
//                           return placesId.isEmpty
//                               ? ref.watch(sheetHeightProvider).height! == 40.h
//                                   ? Container()
//                                   : Center(
//                                       child: Text(
//                                         'No Quick access (yet!)',
//                                         style: getMediumStyle(
//                                             color: context.titleColor,
//                                             fontSize: MyFonts.size12),
//                                       ),
//                                     )
//                               : Expanded(
//                                   child: Container(
//                                     color: MyColors.white,
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       itemCount: placesId.length,
//                                       itemBuilder: (context, index) {
//                                         final String placeId = placesId[index];
//                                         return ref
//                                             .watch(getPlacesByIdProvider(placeId))
//                                             .when(
//                                                 data: (place) {
//                                                   return InkWell(
//                                                     onTap: () {
//                                                       Navigator.pushNamed(
//                                                           context,
//                                                           AppRoutes
//                                                               .detailResturantScreen,
//                                                           arguments: {
//                                                             'placeModel': place
//                                                           });
//                                                     },
//                                                     child:
//                                                         PlaceNameAndLocationContainer(
//                                                       title: place!.placeName,
//                                                       subTitle:
//                                                           place.locationName,
//                                                     ),
//                                                   );
//                                                 },
//                                                 error: (error, stack) =>
//                                                     SizedBox(),
//                                                 loading: () => ListView.builder(
//                                                     itemCount: 3,
//                                                     shrinkWrap: true,
//                                                     physics:
//                                                         NeverScrollableScrollPhysics(),
//                                                     itemBuilder:
//                                                         (context, index) {
//                                                       return QuickAccessContainerShimmer();
//                                                     }));
//                                       },
//                                     ),
//                                   ),
//                                 );
//                         },
//                         error: (error, stack) => Text('Loading'),
//                         loading: () => ListView.builder(
//                             itemCount: 3,
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return QuickAccessContainerShimmer();
//                             }),
//                       ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// // Widget Item(
// //         {required BuildContext context,
// //         required String title,
// //         required String subTitle}) =>
// //     Container(
// //         padding: EdgeInsets.all(12.r),
// //         margin: EdgeInsets.symmetric(vertical: 8.h),
// //         decoration: BoxDecoration(
// //             color: MyColors.white,
// //             borderRadius: BorderRadius.circular(8.r),
// //             boxShadow: [
// //               BoxShadow(
// //                 blurRadius: 20,
// //                 spreadRadius: 0,
// //                 offset: Offset(0, 0),
// //                 color: context.titleColor.withOpacity(.10),
// //               ),
// //             ]),
// //         child: Container(
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     title, //'LA Fitness',
// //                     style: getSemiBoldStyle(
// //                       color: context.titleColor,
// //                       fontSize: MyFonts.size16,
// //                     ),
// //                   ),
// //                   Text(
// //                     subTitle, //'1101 Connecticut Ave NW',
// //                     style: getMediumStyle(
// //                       color: context.titleColor.withOpacity(.5),
// //                       fontSize: MyFonts.size13,
// //                     ),
// //                   )
// //                 ],
// //               ),
// //               Icon(
// //                 Icons.arrow_forward_ios_outlined,
// //                 color: context.titleColor,
// //                 size: 18.r,
// //               )
// //             ],
// //           ),
// //         ));
// }
//
//  */
