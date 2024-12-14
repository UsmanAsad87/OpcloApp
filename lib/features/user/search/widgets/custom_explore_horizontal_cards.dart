import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_enum/banner_type.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/features/user/home/home_extended/carousel/widgets/home_banner_one.dart';
import 'package:opclo/utils/constants/assets_manager.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_shimmer/loading_images_shimmer.dart';
import '../../../../models/crousel_model.dart';
import '../../home/home_extended/carousel/controller/carousel_controller.dart';

class CustomExploreHorizontalCards extends StatelessWidget {
   CustomExploreHorizontalCards({Key? key}) : super(key: key);

  final images = [AppAssets.browseImage, AppAssets.navigateImage];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child:
      ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 2,
          // physics: NeverScrollableScrollPhysics(),
          // shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.only(left: 18.w,bottom: 2.h),
                width: 324.w,
                height: 167.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(1,1),
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: MyColors.black.withOpacity(.05)
                    )
                  ]


                ),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(images[index], fit: BoxFit.fitHeight),
            ), // HomeBannerOne(carousel : exploreBanners[index], margin: index == 0 ? 18.w : 12.w,);
          );}
      // Consumer(builder: (context, ref, child) {
      //   return ref.watch(fetchAllCarouselProvider).when(
      //       data: (carousels) {
      //         List<CarouselModel> exploreBanners = carousels
      //             .where((carousel) => carousel.bannerType == BannerTypeEnum.explore)
      //             .toList();
      //         return ListView.builder(
      //             padding: EdgeInsets.zero,
      //             itemCount: exploreBanners.length,
      //             // physics: NeverScrollableScrollPhysics(),
      //             // shrinkWrap: true,
      //             scrollDirection: Axis.horizontal,
      //             physics: BouncingScrollPhysics(),
      //             itemBuilder: (context, index) {
      //               return HomeBannerOne(carousel : exploreBanners[index], margin: index == 0 ? 18.w : 12.w,);
      //             });
      //       },
      //       error: (error, stackTrace) => Text('Error $error'),
      //       loading: () => ShimmerWidget());
      // }),
      ) );
  }
}
