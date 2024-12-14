import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/cached_retangular_network_image.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';

class SuccessStories extends StatefulWidget {
  const SuccessStories({
    super.key,
  });

  @override
  State<SuccessStories> createState() => _SuccessStoriesState();
}

class _SuccessStoriesState extends State<SuccessStories> {
  List<String> review = [
  "With the savings and perks from the premium subscription, it paid for itself in no time!",
  "Opclo’s premium plan made my travels seamless. Worth every penny!",
  "Premium subscription elevates my daily routine. Fantastic value.",
  ];
  List<String> reviewerName = ["Sarah", "Jennifer", "Shawn"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
          child: Row(
            children: [
              Text(
                'Success Stories',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size16),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 3,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16.r),
                  margin:
                  EdgeInsets.symmetric(vertical: 16.r, horizontal: 12.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: MyColors.containerPurpleColor.withOpacity(0.7),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedRectangularNetworkImageWidget(
                          image:"", width: 40, height: 40,name:reviewerName[index],),
                      padding16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 240.w,
                              child: Text(
                                review[index],
                                style: getRegularStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size11),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                reviewerName[index],
                                style: getSemiBoldStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size11),
                              ),
                              padding4,
                              Row(
                                children: List.generate(
                                  5,
                                      (index) => const Icon(
                                    Icons.star,
                                    color: MyColors.starContainerColor,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
