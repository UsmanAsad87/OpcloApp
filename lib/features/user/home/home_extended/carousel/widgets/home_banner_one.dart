import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opclo/commons/common_widgets/cached_retangular_network_image.dart';
import 'package:opclo/models/crousel_model.dart';
import '../../../../../../commons/common_functions/open_map.dart';
import '../../../../../../routes/route_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../../../../utils/thems/my_colors.dart';
import '../../../../../../utils/thems/styles_manager.dart';
import '../../../widgets/container_button.dart';

class HomeBannerOne extends StatelessWidget {
  final CarouselModel carousel;
  final double margin;

  const HomeBannerOne({Key? key, required this.carousel, required this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(carousel.clickable){
          launchWebsiteUrl(context: context, url: carousel.link);
        // Navigator.pushNamed(context, AppRoutes.articles,
        //     arguments: {'model': carousel});
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        margin: EdgeInsets.only(left: margin ?? 18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: [
              carousel.color1,
              carousel.color2,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        width: 324.w,
        height: 167.h,
        child: Stack(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: Text(
                          carousel.header, //'Discovery hub, Offers & Alerts',
                          style: getBoldStyle(
                              color: Colors.yellow,
                              fontSize: MyFonts.size15)),
                    ),
                    SizedBox(
                      width: 150.w,
                      child: Text(
                          carousel.shortDesc,
                          style: GoogleFonts.poppins(
                            color: MyColors.white,
                            fontSize: MyFonts.size22,
                            fontWeight: FontWeight.bold,
                            decorationColor: MyColors.green,
                            // backgroundColor: MyColors.white,
                          )),
                    ),
                    if (carousel.clickable)
                      ContainerButton(
                        buttonText: carousel.buttonText,
                        fontSize: 11.r,
                        borderRadius: 7.r,
                        color: MyColors.containerColor1,
                        onPressed: () {
                          launchWebsiteUrl(context: context, url: carousel.link);
                          // Navigator.pushNamed(context, AppRoutes.articles,
                          //     arguments: {'model': carousel});
                        },
                      ),
                  ],
                ),
                // Expanded(
                //     child: CachedRectangularNetworkImageWidget(image: carousel.image,width: 150,height: 150,)
                // Image.network(carousel.image, scale: 6,)
                //     Image.asset(
                //   AppAssets.nearByPinIcon,
                //   scale: 11.r,
                // )
                // )
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CachedRectangularNetworkImageWidget(
                image: carousel.image,
                width: 150,
                height: 150,
              ),
            )
          ],
        ),
      ),
    );
  }
}
