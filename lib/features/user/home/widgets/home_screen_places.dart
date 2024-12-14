import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/home/widgets/places_row.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import '../../../../commons/common_functions/service_enabled.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../commons/common_widgets/custom_see_all_widget.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../location/location_controller/location_notifier_controller.dart';

class HomeScreenPlaces extends ConsumerStatefulWidget {
  const HomeScreenPlaces({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenPlaces> createState() => _PlacesState();
}

class _PlacesState extends ConsumerState<HomeScreenPlaces> {
  bool locationEnabled = true;

  final categoriesId = [
    'nearby',
    // AppConstants().dinning,
    // AppConstants().thingsTodo,
    // AppConstants().shopping,
    // AppConstants().activeLife,
    // AppConstants().exploreOutdoor,
    // AppConstants().travel,
  ];

  final filters = [
    'Nearby'
    // 'Top Picks for You',
    // 'Eat & Drink',
    // 'Things to Do',
    // 'Shopping',
    // 'Active Life',
    // 'Explore Outdoors',
    // 'Travel and Transportation',
  ];

  int _currentLoadingIndex = 0;

  void _handleLoadingCompleted() {
    if (mounted) {
      setState(() {
        _currentLoadingIndex++;
      });
    }
  }

  @override
  void initState() {
    checkLocationPermission();
    super.initState();
  }

  checkLocationPermission() async {
    if (ref.read(locationDetailNotifierCtr).locationDetail == null) {
      locationEnabled = await serviceEnabled();
      if (!locationEnabled) {
        setState(() {});
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return locationEnabled
        ? ListView.builder(
            itemCount: filters.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _currentLoadingIndex >= index
                  ? PlacesRow(
                      categoryId: categoriesId[index],
                      categoryName: filters[index],
                      isTopPlaces: false,
                      // isTopPlaces: index == 0 ? true : false,
                      onLoadingCompleted: _handleLoadingCompleted,
                    ) : Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSeeAllWidget(
                            title: filters[index],
                            buttonTextColor: context.primaryColor,
                            onTap: () {},
                        ),
                        padding8,
                        SizedBox(
                          height: 260.h,
                          child: PlaceListShimmer(
                            count: 5,
                            scrollDirection: Axis.horizontal,
                            cardWidth: 300.w,
                            cardRightMargin: 8.w,
                            leftMargin: true,
                            physics: const BouncingScrollPhysics(),
                          ),
                        )
                      ],
                    );
            },
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              padding12,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.noLocationImage,
                    width: 150.w,
                    height: 130.h,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Location Services turned off',
                      style: getSemiBoldStyle(
                          color: context.titleColor, fontSize: MyFonts.size12),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Text(
                        'Please enable location access to use Opclo',
                        textAlign: TextAlign.center,
                        style: getMediumStyle(
                            color: context.titleColor.withOpacity(.3),
                            fontSize: MyFonts.size11),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                onPressed: () async {
                  final isEnable = await enableService();
                  if (isEnable) {
                    setState(() {
                      locationEnabled = true;
                    });
                  }
                },
                buttonText: 'Enable Now',
                buttonWidth: 160.w,
                buttonHeight: 38.w,
              )
            ],
          );
  }
}
