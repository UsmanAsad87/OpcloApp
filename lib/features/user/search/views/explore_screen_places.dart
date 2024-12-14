// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:opclo/core/extensions/color_extension.dart';
// import '../../../../commons/common_functions/padding.dart';
// import '../../../../commons/common_functions/service_enabled.dart';
// import '../../../../commons/common_imports/apis_commons.dart';
// import '../../../../commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
// import '../../../../commons/common_widgets/custom_button.dart';
// import '../../../../commons/common_widgets/custom_see_all_widget.dart';
// import '../../../../utils/constants/assets_manager.dart';
// import '../../../../utils/constants/font_manager.dart';
// import '../../../../utils/thems/styles_manager.dart';
// import '../../home/widgets/places_row.dart';
// import '../../location/location_controller/location_notifier_controller.dart';
//
// class ExploreScreenPlaces extends ConsumerStatefulWidget {
//   const ExploreScreenPlaces({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<ExploreScreenPlaces> createState() => _ExploreScreenPlacesState();
// }
//
// class _ExploreScreenPlacesState extends ConsumerState<ExploreScreenPlaces> {
//   bool locationEnabled = true;
//
//   @override
//   void initState() {
//     checkLocationPermission();
//     super.initState();
//   }
//
//   checkLocationPermission() async {
//     if (ref.read(locationDetailNotifierCtr).locationDetail == null) {
//       locationEnabled = await serviceEnabled();
//       if (!locationEnabled) {
//         setState(() {});
//         return;
//       }
//       setState(() {});
//     }
//   }
//
//   final categoriesId = [
//     '',
//     '',
//     '14000%2C14001%2C14002%2C14003%2C14004%2C14005%2C14006%2C14007%2C14008%2C14009%2C14010%2C14011%2C14012%2C14013%2C14014%2C14015%2C14016'
//   ];
//
//   final filters = ['Nearby', 'Under 10 mins', 'Events'];
//
//   int _currentLoadingIndex = 0;
//
//   void _handleLoadingCompleted() {
//     if (mounted)
//       setState(() {
//         _currentLoadingIndex++;
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return locationEnabled
//         ? ListView.builder(
//             itemCount: filters.length,
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return _currentLoadingIndex >= index
//                   ? PlacesRow(
//                       categoryId: categoriesId[index],
//                       categoryName: filters[index],
//                       radius: index == 0
//                           ? 800
//                           : index == 1
//                               ? 500
//                               : null,
//                       onLoadingCompleted: _handleLoadingCompleted,
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomSeeAllWidget(title: filters[index], onTap: () {}),
//                         SizedBox(
//                           height: 260.h,
//                           // width: 260.h,
//                           child: PlaceListShimmer(
//                             count: 5,
//                             scrollDirection: Axis.horizontal,
//                             cardWidth: 300.w,
//                             cardRightMargin: 8.w,
//                             leftMargin: true,
//                             physics: BouncingScrollPhysics(),
//                           ),
//                         )
//                       ],
//                     );
//             },
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               padding12,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     AppAssets.noLocationImage,
//                     width: 150.w,
//                     height: 130.h,
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.all(12.r),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Location Services turned off',
//                       style: getSemiBoldStyle(
//                           color: context.titleColor, fontSize: MyFonts.size12),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 18.w),
//                       child: Text(
//                         'Please enable location access to use Opclo',
//                         textAlign: TextAlign.center,
//                         style: getMediumStyle(
//                             color: context.titleColor.withOpacity(.3),
//                             fontSize: MyFonts.size11),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               CustomButton(
//                 onPressed: () async {
//                   final isEnable = await enableService();
//                   if (isEnable) {
//                     setState(() {
//                       locationEnabled = true;
//                     });
//                   }
//                 },
//                 buttonText: 'Enable Now',
//                 buttonWidth: 160.w,
//                 buttonHeight: 38.w,
//               )
//             ],
//           );
//   }
// }
