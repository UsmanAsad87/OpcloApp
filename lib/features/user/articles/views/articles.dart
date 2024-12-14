import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/models/crousel_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../reminder/api/dynamic_link_service.dart';

class Articles extends StatelessWidget {
  final CarouselModel model;
  const Articles({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SafeArea(
              child: Container(
                color: MyColors.articleContainer1,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(AppConstants.allPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: context.whiteColor,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              DynamicLinkService.buildDynamicLinkForBanner(
                                  true, model);
                            },
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            child: Icon(
                              Icons.file_upload_outlined,
                              color: context.whiteColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    padding40,
                    Image.asset(
                      AppAssets.articlesImage,
                      width: 190.w,
                      height: 215.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: MyColors.articleContainer2,
              child: Padding(
                padding: EdgeInsets.all(AppConstants.allPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FEATURE',
                      style: getMediumStyle(
                          color: context.whiteColor.withOpacity(.7.r),
                          fontSize: MyFonts.size13),
                    ),
                    Row(
                      children: [
                        Text(
                          model.header, // model.articleTitle,
                          style: getSemiBoldStyle(
                              color: context.whiteColor, fontSize: MyFonts.size20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(AppConstants.allPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.shortDesc, //model.articleDesc,
                    textAlign: TextAlign.start,
                    style: getRegularStyle(
                        color: context.titleColor, fontSize: MyFonts.size14),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
