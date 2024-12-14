import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/custom_see_all_widget.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/main_menu/controller/conectivity_notifier.dart';
import 'package:opclo/features/user/search/widgets/custom_explore_horizontal_cards.dart';
import 'package:opclo/features/user/search/widgets/search_button.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../commons/common_functions/check_conectivity.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../no_internet/views/no_connection.dart';
import '../constants/popular_store.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    AnalyticsHelper.logScreenView(screenName: 'Explore-Screen');
    super.initState();
  }

  bool showAll = false;
  final nearYou = [
    'Dining &\nDrinking',
    'Arts &\nEntertain\nment',
    'Nightlife &\nEntertain\nment',
    'Food\nExperien\nces',
    'Events',
    'Retail\nShopping',
    'Culture &\nHeritage',
    'Landmarks &\nOutdoors',
    'Family &\nKids',
    'Night Markets\n& Shopping\nEvents',
    'Sports &\nRecreation',
    'Adventure\n& Leisure\nActivities',
    'Seasonal\nActivities',
    'Unique &\nHidden\nGems',
    'Fitness &\nWellness\nRetreats',
    'Health &\nWellness',
    'Beauty &\nPersonal\nCare',
    'Transportation\nHubs &\nServices',
    'Travel &\nTransport\nation',
    'Tech &\nInnovation',
    'Professional\nServices',
    'Luxury &\nHigh-End\nExperiences ',
    'Volunteer\n& Social\nImpact',
    'Automotive',
    'Home &\nGarden',
    'Pets',
    'Education\n& Learning',
    'Media &\nCommun\nication',
    'Photography\n\& Filmmaking\nLocations',
    'Religious\n\& Spiritual\nSites',
    'Finance &\nInsurance',
    'Real\nEstate',
    'Eco-Friendly &\nSustainable\nLiving',
    'Emergency\n& Safety\nServices',
    'Wedding\n& Special\nEvents',
    'Craft &\nDIY',
    'Utilities\n& Public\nServices',
    'Community\n&\nGovernment',
  ];

  final nearYouIds = [
    AppConstants().dinning,
    '${AppConstants().thingsTodo}%2C10069',
    PlacesIds().nightLifeAndEnter,
    PlacesIds().foodExp,
    PlacesIds().event,
    PlacesIds().retailShopping,
    PlacesIds().cultureAndHeritage,
    PlacesIds().landMarkAndOutdoor,
    PlacesIds().familyAndKids,
    PlacesIds().nightMarket,
    PlacesIds().sportAndRecreation,
    PlacesIds().AdventureAndLeisure,
    PlacesIds().seasonal,
    PlacesIds().gems,
    PlacesIds().fitness,
    PlacesIds().health,
    PlacesIds().beauty,
    PlacesIds().transportation,
    PlacesIds().travel,
    PlacesIds().tech,
    PlacesIds().professionalServices,
    PlacesIds().luxury,
    PlacesIds().socialImpact,
    PlacesIds().automotive,
    PlacesIds().homeAndGreen,
    PlacesIds().pets,
    PlacesIds().education,
    PlacesIds().media,
    PlacesIds().photography,
    PlacesIds().religious,
    PlacesIds().finance,
    PlacesIds().realEstate,
    PlacesIds().emergency,
    PlacesIds().wedding,
    PlacesIds().craft,
    PlacesIds().utilities,
    PlacesIds().communities,
  ];

  List<String> nearYouIcon = [
    AppAssets.diningDrinkingIcon,
    AppAssets.artIcon,
    AppAssets.nightLifeIcon,
    AppAssets.foodIcon,
    AppAssets.eventsIcon,
    AppAssets.retailIcon,
    AppAssets.cultureIcon,
    AppAssets.landmarkIcon,
    AppAssets.familyIcon,
    AppAssets.marketIcon,
    AppAssets.sportsIcon1,
    AppAssets.adventureIcon,
    AppAssets.seasonalIcon,
    AppAssets.gemsIcon,
    AppAssets.fitnessIcon,
    AppAssets.healthIcon,
    AppAssets.beautyIcon,
    AppAssets.transportationIcon,
    AppAssets.travelIcon1,
    AppAssets.techIcon,
    AppAssets.professionalServicesIcon,
    AppAssets.luxuryIcon,
    AppAssets.socialIcon,
    AppAssets.automotiveIcon,
    AppAssets.decorationIcon,
    AppAssets.petsIcon,
    AppAssets.educationIcon,
    AppAssets.mediaIcon,
    AppAssets.photographyIcon,
    AppAssets.religiousIcon,
    AppAssets.financeIcon,
    AppAssets.realEstateIcon,
    AppAssets.ecoFriendlyIcon,
    AppAssets.emergencyIcon,
    AppAssets.weddingsIcon,
    AppAssets.craftIcon,
    AppAssets.utilitiesIcon,
    AppAssets.communitiesIcon,
  ];

  @override
  Widget build(BuildContext context) {
    bool isInternet = ref.watch(connectivityProvider);
    return !isInternet
        ? NoConnection(
            isPop: false,
            onTap: () async {
              isInternet = await isInternetConnected();
              if (isInternet) {
                setState(() {});
              } else {
                showToast(
                    msg: 'No Connection yet',
                    backgroundColor: context.primaryColor.withOpacity(.2));
              }
            },
          )
        : Scaffold(
            backgroundColor: context.whiteColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'Explore',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size26),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, AppRoutes.mapScreen);
                    Navigator.pushNamed(context, AppRoutes.mapView);
                  },
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: .5.w,
                            color: context.titleColor.withOpacity(.2)),
                      ),
                      child: Image.asset(
                        AppAssets.mapMarkerImage,
                        width: 16,
                      )),
                ),
                padding8,
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchButton(),
                    padding16,
                    CustomSeeAllWidget(
                        title: 'Popular Stores',
                        buttonText: '',
                        fontSize: MyFonts.size18,
                        onTap: () {}),
                    Container(
                      height: 120.h,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: ListView.builder(
                          itemCount: PopularStoreConstant.storeName.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 16.w : 0, right: 12.w),
                              child: InkWell(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.placeChainScreen,
                                      arguments: {
                                        'categoryName': PopularStoreConstant
                                            .storeName[index],
                                        'chainId': PopularStoreConstant
                                            .storeChainId[index]
                                      });
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 32.r,
                                      child: ClipOval(
                                        child: Image.asset(
                                          PopularStoreConstant.storeLogo[index],
                                          fit: index == 5 || index == 8
                                              ? BoxFit.fitHeight
                                              : BoxFit.cover,
                                          width: 64.r,
                                          height: 64.r,
                                        ),
                                      ),
                                    ),
                                    padding4,
                                    Text(
                                      PopularStoreConstant.storeName[index],
                                      style: getRegularStyle(
                                          color: context.bodyTextColor,
                                          fontSize: 12.r),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    padding16,
                    CustomExploreHorizontalCards(),
                    padding16,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Explore Near You',
                            style: getSemiBoldStyle(
                                color: context.titleColor,
                                fontSize: MyFonts.size16),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(AppConstants.allPadding),
                      child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          //itemCount: showAll ? nearYou.length : 4,
                          itemCount: nearYou.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 8.h,
                            childAspectRatio: 1.7.r,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.placeslistScreen,
                                  arguments: {
                                    'categoriesId': nearYouIds[index],
                                    'categoryName':
                                        nearYou[index].replaceAll('\n', ' '),
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: context.whiteColor,
                                    borderRadius: BorderRadius.circular(
                                      12.r,
                                    ),
                                    border: Border.all(
                                        color: Color(0xffE7E7ED), width: 1.sp)),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(12.0),
                                              bottomRight:
                                                  Radius.circular(12.0),
                                            ),
                                            child: Image.asset(
                                              nearYouIcon[index],
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, top: 8.h),
                                        child: Text(
                                          nearYou[index],
                                          style: getMediumStyle(
                                              color: context.titleColor,
                                              fontSize: MyFonts.size14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    // ExploreScreenPlaces()
                  ]),
            ));
  }
}
