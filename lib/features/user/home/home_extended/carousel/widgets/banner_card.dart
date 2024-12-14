import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opclo/commons/common_widgets/cached_retangular_network_image.dart';
import 'package:opclo/models/crousel_model.dart';
import '../../../../../../routes/route_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../../utils/thems/my_colors.dart';
import '../../../../../../utils/thems/styles_manager.dart';
import '../../../widgets/container_button.dart';

class BannerCard extends StatelessWidget {
  final CarouselModel carousel;

  const BannerCard({Key? key, required this.carousel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.only(left: 18.w),
      width: 334.w,
      height: 167.h,
      child: Stack(
        children: [
          Container(
            width: 334.w,
            height: 167.h,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            // child: ClipRRect(
            //     borderRadius: BorderRadius.circular(12.r),
            //     child: CachedRectangularNetworkImageWidget(
            //       image: carousel.image,
            //       width: 334,
            //       height: 167,
            //     )),
          ),
          Container(
            width: 334.w,
            height: 167.h,
            decoration:
            BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              color: MyColors.black.withOpacity(.3)
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  carousel.header,
                  style: getLobsterBoldStyle(
                      color: MyColors.green, fontSize: MyFonts.size16),
                ),
                SizedBox(
                  width: 150.w,
                  child: Text(
                    carousel.shortDesc,
                    style:  GoogleFonts.poppins(
                      color: MyColors.white,
                      fontSize: MyFonts.size18,
                      fontWeight: FontWeight.bold,
                      decorationColor: MyColors.green,
                      // backgroundColor: MyColors.white,
                    )
                  ),
                ),
                ContainerButton(
                  buttonText: 'LET\'s Go',
                  fontSize: 11.r,
                  borderRadius: 7.r,
                  color: MyColors.containerColor1,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.articles,
                        arguments: {'model': carousel});
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
