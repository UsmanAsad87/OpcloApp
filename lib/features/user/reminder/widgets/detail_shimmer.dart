import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../restaurant/widgets/custom_about_button.dart';

class DetailShimmer extends StatelessWidget {
  const DetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: context.whiteColor,
        leading: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        centerTitle: true,
        title: ShimmerWidget(
          width: 60,
          height: 20,
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                height: 30.h,
                width: 30.w,
                highlightColor: Colors.green,
              ),
              padding4,
              ShimmerWidget(
                height: 30.h,
                width: 30.w,
                highlightColor: MyColors.red,
              ),
              padding4,
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: context.titleColor,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                    height: 116.h,
                    child: ShimmerWidget(
                      height: 200.h,
                    )),
                Positioned(
                  bottom: -30.h,
                  right: 30.w,
                  child: CustomButton(
                      buttonWidth: 130.w,
                      buttonHeight: 40.h,
                      onPressed: () {
                        // openMap(placeModel: placeModel);
                      },
                      icon: Icon(
                        Icons.directions,
                        size: 23.r,
                        color: context.whiteColor,
                      ),
                      borderRadius: 10.r,
                      buttonText: 'Directions'),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 2.h),
                          child: Image.asset(
                            AppAssets.starIconImage,
                            width: 18.w,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
                      child: ShimmerWidget(
                        width: 60.w,
                        height: 30.h,
                      )),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 4.h),
                          child: ShimmerWidget(
                            width: 60.w,
                            height: 30.h,
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 4.h),
                          child: ShimmerWidget(
                            width: 60.w,
                            height: 30.h,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [
                  ShimmerWidget(
                    width: 100.w,
                    height: 100.h,
                  ),
                  padding4,
                  ShimmerWidget(
                    width: 100.w,
                    height: 100.h,
                  ),
                  padding4,
                  ShimmerWidget(
                    width: 100.w,
                    height: 100.h,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomAboutButton(
                    onTap: () {},
                    text: 'Website',
                    image: AppAssets.globeIconImage,
                    fillColor: context.primaryColor,
                  ),
                  CustomAboutButton(
                      onTap: () {}, icon: Icons.phone, text: 'Call'),
                  CustomAboutButton(
                      onTap: () async {},
                      icon: Icons.directions,
                      text: 'Directions'),
                  CustomAboutButton(
                      onTap: () {},
                      image: AppAssets.shareAppImage,
                      text: 'Share'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(AppConstants.padding),
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0xffFFFFFF),
                      Color(0xffF4EBE0),
                    ],
                    stops: [
                      0.1,
                      7,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                    child: Image.asset(
                      AppAssets.fastFoodImage,
                      width: 110.w,
                      height: 70.h,
                    ),
                  ),
                  padding4,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delicious Food',
                          style: getSemiBoldStyle(
                              color: MyColors.foodTextColor,
                              fontSize: MyFonts.size16)),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                            'Get your latest offers today at our nearest stores',
                            style: getMediumStyle(
                                color: context.titleColor,
                                fontSize: MyFonts.size11)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppConstants.padding),
              margin: EdgeInsets.symmetric(
                horizontal: AppConstants.padding,
              ),
              decoration: BoxDecoration(
                  color: context.containerColor,
                  borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Color(0xffF26C4F),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: context.whiteColor,
                    ),
                  ),
                  padding12,
                  Expanded(
                    child: Text(
                        ' “Our app utilizes a location-based API. We’re constantly enhancing its performance.”',
                        style: getRegularStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size13)),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: AppConstants.horizontalPadding, top: 18.h),
              child: Text(
                'Alerts',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: AppConstants.horizontalPadding, top: 18.h, bottom: 6.h),
              child: Text(
                'Occasions',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size18),
              ),
            ),
            padding8,
            Container(
              width: double.infinity,
              color: MyColors.subContainer1.withOpacity(.2),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.h,
                      top: 50.h,
                    ),
                    child: Text(
                      'Love it here?',
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 2.h, top: 2.h, left: 12.w, right: 12.w),
                    child: Text(
                      'To stay up to date with the latest charges and news, please follow us on social media',
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                          color: context.titleColor.withOpacity(.5),
                          fontSize: MyFonts.size13),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(
                      '@OpcloApp',
                      style: getSemiBoldStyle(
                          color: context.primaryColor.withOpacity(.9),
                          fontSize: MyFonts.size15),
                    ),
                  ),
                  Image.asset(
                    AppAssets.poweredByImage,
                    width: 220.w,
                  ),
                  padding56,
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalPadding,
                        vertical: 18.r),
                    child: CustomButton(
                      onPressed: () {},
                      buttonText: 'Report Place',
                      backColor: MyColors.pizzaHutColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
