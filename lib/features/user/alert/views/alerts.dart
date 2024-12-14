import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/widgets/icon_widget.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../commons/common_imports/common_libs.dart';

class Alerts extends StatelessWidget {
  Alerts({Key? key}) : super(key: key);

  final List<String> alerts_text = [
    'Covid-19',
    'Hours',
    'Moved Location',
    'Temporarily Close',
    'Dine-in/Drive-thru',
    'Black or Women owned',
    'Occasions',
    'Recommendations'
  ];

  final List<String> routes = [
    AppRoutes.covidScreen,
    AppRoutes.hoursScreen,
    AppRoutes.movedLocation,
    AppRoutes.temporarilyClose,
    AppRoutes.dineInOrDineThru,
    AppRoutes.blackOrWomenOwned,
    AppRoutes.occasionsScreen,
    AppRoutes.recommendationScreen,
  ];

  final List<String> alerts = [
    AppAssets.covidImage,
    AppAssets.hoursImage,
    AppAssets.locationImage,
    AppAssets.closeImage,
    AppAssets.driveImage,
    AppAssets.womenImage,
    AppAssets.occasionImage,
    AppAssets.recommendationsImage
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: context.whiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'Send Reports',
          style: getSemiBoldStyle(
            color: context.titleColor,
            fontSize: MyFonts.size18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstants.allPadding),
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: alerts.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, routes[index]);
                      },
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: MyColors.gridViewContainerColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconWidget(
                              icon:  alerts[index],
                              size: index == 6 || index == 0 ? 80 : 45,
                              padding:  index == 6 || index == 0 ? 0.r : 16.r,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                alerts_text[index],
                                textAlign: TextAlign.center,
                                style: getMediumStyle(
                                    color: context.titleColor,
                                    fontSize: MyFonts.size13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              child: Text(
                'Alerts are public. Your Opclo username will not appear with your alert.',
                textAlign: TextAlign.center,
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.3.r),
                    fontSize: MyFonts.size13),
              ),
            )
          ],
        ),
      ),
    );
  }
}
