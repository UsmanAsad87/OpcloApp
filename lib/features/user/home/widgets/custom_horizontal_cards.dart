import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/features/user/home/home_extended/carousel/controller/carousel_controller.dart';
import 'package:opclo/features/user/home/home_extended/carousel/widgets/banner_card.dart';
import 'package:opclo/features/user/home/home_extended/carousel/widgets/home_banner_one.dart';

import '../../../../commons/common_enum/banner_type.dart';
import '../../../../models/crousel_model.dart';

class CustomHorizontalCards extends StatelessWidget {
  const CustomHorizontalCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Consumer(builder: (context, ref, child) {
        return ref.watch(fetchAllCarouselProvider).when(
            data: (carousels) {
              List<CarouselModel> homeBanners = carousels
                  .where((carousel) => carousel.bannerType == BannerTypeEnum.home)
                  .toList();
              return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: homeBanners.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return HomeBannerOne(
                      carousel: homeBanners[index],
                      margin: index == 0 ? 18.w : 12.w,
                    );
                  });
            },
            error: (error, stackTrace) => SizedBox(),
            loading: () => ShimmerWidget());
      }),
    );
  }
}
