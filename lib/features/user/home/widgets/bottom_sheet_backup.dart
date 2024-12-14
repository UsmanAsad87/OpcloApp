// import 'package:opclo/core/extensions/color_extension.dart';
// import 'package:opclo/features/user/home/widgets/place_name_and_location_container.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// import '../../../../commons/common_imports/apis_commons.dart';
// import '../../../../commons/common_imports/common_libs.dart';
// import '../../../../commons/common_providers/shared_pref_helper.dart';
// import '../../../../utils/constants/font_manager.dart';
// import '../../../../utils/loading.dart';
// import '../../../auth/controller/auth_controller.dart';
// import '../../../auth/controller/auth_notifier_controller.dart';
// import '../../main_menu/controller/main_menu_controller.dart';
// import '../../profile/profile_extended/add_note/views/add_location.dart';
// import '../../restaurant/controller/places_controller.dart';
//
// class BottomSheetHomePage extends ConsumerStatefulWidget {
//   const BottomSheetHomePage({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<BottomSheetHomePage> createState() =>
//       _BottomSheetHomePageState();
// }
//
// class _BottomSheetHomePageState extends ConsumerState<BottomSheetHomePage> {
//   late DraggableScrollableController _scrollController;
//   late ScrollController _scrollController1;
//   double currentSize = 0.0;
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = DraggableScrollableController();
//     _scrollController1 = ScrollController();
//
//     _scrollController.addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _scrollController.removeListener(_scrollListener);
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     currentSize= _scrollController.size;
//     print("Current DraggableScrollableSheet size: $currentSize");
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return buildGestureDetector();
//   }
//
//
//   GestureDetector buildGestureDetector() {
//     return GestureDetector(
//       onVerticalDragStart: (val){
//         _scrollController.animateTo(
//           0.5,
//           duration: Duration(milliseconds: 500),
//           curve: Curves.ease,
//         );
//       },
//       onVerticalDragEnd: (val){
//         print('In Else: !');
//
//         if(_scrollController.pixels.floor() > 0.5){
//           _scrollController.animateTo(
//             0.5,
//             duration: Duration(milliseconds: 500),
//             curve: Curves.ease,
//           );
//         }else{
//           _scrollController.animateTo(
//             0.0,
//             duration: Duration(milliseconds: 500),
//             curve: Curves.ease,
//           );
//         }
//       },
//       onTap: () {
//
//         if(_scrollController.isAttached){
//           _scrollController.animateTo(
//             0.5,
//             duration: Duration(milliseconds: 500),
//             curve: Curves.ease,
//           );
//         }
//       },
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.05,
//         minChildSize: 0.05,
//         snap: true,
//         snapSizes: [
//           ref.watch(authNotifierCtr).userModel == null ? 0.3 : 0.45,
//         ],
//         snapAnimationDuration: Duration(milliseconds: 400),
//         maxChildSize: ref.watch(authNotifierCtr).userModel == null ? 0.3 : 0.9,
//         controller: _scrollController,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return SingleChildScrollView(
//             physics:   NeverScrollableScrollPhysics(),
//             controller: _scrollController.isAttached?  _scrollController1: scrollController,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       color: MyColors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20.r),
//                         topRight: Radius.circular(20.r),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(0, 10.h),
//                           blurRadius: 12.r,
//                           spreadRadius: 3.r,
//                         )
//                       ]),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       ListView(
//                         shrinkWrap: true,
//                         padding: EdgeInsets.zero,
//                         controller: _scrollController.isAttached?  null: scrollController,
//                         children: [
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           Center(
//                             child: Container(
//                               height: 5.h,
//                               width: 50.w,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.r),
//                                 color: MyColors.darkLightTextColor.withOpacity(0.5),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20.h,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16.w),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Quick Access',
//                                   style: getSemiBoldStyle(
//                                     color: context.titleColor,
//                                     fontSize: MyFonts.size18,
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     ref.watch(authNotifierCtr).userModel == null
//                                         ? ref.watch(mainMenuProvider).setIndex(4)
//                                         : _showSheet(context);
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(4.r),
//                                     decoration: BoxDecoration(
//                                       color: context.primaryColor,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.add_outlined,
//                                       size: 23.r,
//                                       color: context.whiteColor,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                         ],
//                       ),
//                       Container(
//                         child: ref.watch(authNotifierCtr).userModel == null
//                             ? Container(
//                           alignment: Alignment.center,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(top: 12.h),
//                                 child: Text(
//                                   'Login to add quickAccess',
//                                   style: getMediumStyle(
//                                     color: context.titleColor,
//                                     fontSize: MyFonts.size12,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 110.h,
//                               )
//                             ],
//                           ),
//                         )
//                             : ref
//                             .watch(quickAccessStreamProvider(context))
//                             .when(
//                           data: (placesId) {
//                             return placesId.length == 0
//                                 ? Container(
//                               height: 700.h,
//                               color: MyColors.white,
//                               alignment: Alignment.center,
//                               child: Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 30.h,
//                                   ),
//                                   Text(
//                                     'No Places Found!',
//                                     style: getSemiBoldStyle(
//                                         color: MyColors
//                                             .darkContainerColor,
//                                         fontSize: MyFonts.size14),
//                                   ),
//                                 ],
//                               ),
//                             )
//                             // : placesId.length < 7
//                             //     ?
//                                 :
//                             Container(
//                                 height: 580.h,
//                                 color: MyColors.white,
//                                 child: ListView.builder(
//                                   padding: EdgeInsets.zero,
//                                   controller: scrollController,
//                                   shrinkWrap: true,
//                                   physics: BouncingScrollPhysics(),
//                                   itemCount: placesId.length,
//                                   itemBuilder:
//                                       (context, index) {
//                                     final String placeId =
//                                     placesId[index];
//                                     return ref
//                                         .watch(
//                                         getPlacesByIdProvider(
//                                             placeId))
//                                         .when(
//                                       data: (place) {
//                                         return PlaceNameAndLocationContainer(
//                                           title: place!
//                                               .placeName,
//                                           subTitle: place
//                                               .locationName,
//                                           place: place!,
//                                         );
//                                       },
//                                       error:(error, stack) => SizedBox(),
//                                       loading: () =>
//                                           LoadingWidget(),
//                                     );
//                                   },
//                                 ))
//                             // : ListView.builder(
//                             //     padding: EdgeInsets.zero,
//                             //     controller: scrollController,
//                             //     shrinkWrap: true,
//                             //     physics: BouncingScrollPhysics(),
//                             //     itemCount: placesId.length,
//                             //     itemBuilder: (context, index) {
//                             //       final String placeId =
//                             //           placesId[index];
//                             //       return ref
//                             //           .watch(
//                             //               getPlacesByIdProvider(
//                             //                   placeId))
//                             //           .when(
//                             //             data: (place) {
//                             //               return PlaceNameAndLocationContainer(
//                             //                 title: place!
//                             //                     .placeName,
//                             //                 subTitle: place
//                             //                     .locationName,
//                             //                 place: place!,
//                             //               );
//                             //             },
//                             //             error: (error, stack) =>
//                             //                 SizedBox(),
//                             //             loading: () =>
//                             //                 LoadingWidget(),
//                             //           );
//                             //     },
//                             //   )
//                                 ;
//                           },
//                           error: (error, stack) => SizedBox(),
//                           loading: () => LoadingWidget(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
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
// }
