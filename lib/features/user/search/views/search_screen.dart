import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_providers/shared_pref_helper.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/commons/common_widgets/custom_search_fields.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/restaurant/widgets/suggestion_container.dart';
import 'package:opclo/features/user/search/widgets/history_row.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/place_model.dart';
import '../../../../models/search_result_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../location/location_controller/location_notifier_controller.dart';
import '../../location/views/search_location_bootom_sheet.dart';
import '../../restaurant/controller/places_controller.dart';
import '../controller/search_limit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  final categories = [
    AppAssets.heart,
    AppAssets.food,
    AppAssets.gasStation,
    AppAssets.superMarket,
    // AppAssets.more
  ];

  final routes = [
    AppRoutes.favouriteListScreen,
    AppRoutes.placeslistScreen,
    AppRoutes.placeslistScreen,
    // AppRoutes.placesQueryScreen,
    AppRoutes.placeslistScreen,
    // AppRoutes.moreCategoriesScreen
  ];

  final arguments = [
    null,
    {
      'categoriesId': AppConstants().dinning,
      'categoryName': 'Food',
    },
    {'categoriesId': '19007', 'categoryName': 'Gas station'},
    // {'query': 'shell', 'categoryName': 'Gas station'},
    {'categoriesId': AppConstants().groceries, 'categoryName': 'Supermarket'},
    // null,
  ];

  TextEditingController searchController = TextEditingController();
  TextEditingController searchController2 = TextEditingController();
  bool isEmpty = true;
  List<PlaceModel>? result;
  bool isLoading = false;

  @override
  void dispose() {
    searchController.dispose();
    searchController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstants.allPadding),
              child: Column(
                children: [
                  Consumer(builder: (context, ref, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: context.containerColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: CustomSearchField(
                        controller: searchController,
                        verticalPadding: 0,
                        verticalMargin: 0,
                        borderSide: BorderSide.none,
                        hintColor: context.titleColor,
                        hintText: 'where to? ',
                        prefixOnTap: () {
                          Navigator.of(context).pop();
                        },
                        onChanged: (value) async {
                          if (value == '') {
                            setState(() {
                              isEmpty = true;
                            });
                          } else {
                            setState(() {
                              isEmpty = false;
                              isLoading = true;
                            });
                          }
                          final placesAndLink = await ref
                              .read(placesControllerProvider.notifier)
                              .getSearchPlacesQuery(
                                  query: value, context: context);
                          result = placesAndLink.places;
                          setState(() {
                            isLoading = false;
                          });
                        },
                        onEditingComplete: () {
                          final isPrem = ref
                                  .read(authNotifierCtr)
                                  .userModel
                                  ?.subscriptionIsValid ??
                              false;
                          if (!isPrem) {
                            SearchLimiter.incrementSearchCount();
                          }
                          SharedPrefHelper.saveSearchResult(SearchResult(
                              query: searchController.text,
                              timestamp: DateTime.now()));
                          Navigator.pushNamed(
                              context, AppRoutes.searchResultScreen,
                              arguments: {'query': searchController.text});
                        },
                        textInputAction: TextInputAction.search,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: context.titleColor,
                          size: 19.r,
                        ),
                      ),
                    );
                  }),
                  padding8,
                  InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          enableDrag: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return SearchLocationBottomSheet();
                          });
                    },
                    child: Consumer(
                      builder: (context, ref, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: context.containerColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomSearchField(
                            controller: searchController2,
                            verticalPadding: 0,
                            verticalMargin: 0,
                            borderSide: BorderSide.none,
                            hintColor: context.primaryColor,
                            enable: false,
                            hintText: ref
                                        .watch(locationDetailNotifierCtr)
                                        .locationDetail !=
                                    null
                                ? ref
                                    .watch(locationDetailNotifierCtr)
                                    .locationDetail!
                                    .name
                                : 'Current Location',
                            icon: Icon(
                              Icons.location_on,
                              color: context.primaryColor,
                              size: 19.r,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isEmpty) searchNotEnabled() else searchEnabled()

            // ]
          ],
        ),
      ),
    );
  }

  Widget searchNotEnabled() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            padding16,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              height: 80.h,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            // if (index == categories.length - 1) {
                            Navigator.pushNamed(context, routes[index],
                                arguments: arguments[index]);
                            // }
                          },
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            padding: EdgeInsets.all(16.r),
                            margin: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                                color: context.whiteColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      color:
                                          context.titleColor.withOpacity(.05.r),
                                      offset: const Offset(0, 4))
                                ]),
                            child: Image.asset(
                              categories[index],
                              width: 40.w,
                              height: 40.h,
                            ),
                          ),
                        ),
                        padding4,
                      ],
                    ),
                  );
                },
              ),
            ),
            padding8,
            Divider(
              color: context.titleColor.withOpacity(.1.r),
            ),
            padding8,
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.verticalPadding, horizontal: 28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#AdvertiseWithUS',
                    style: getMediumStyle(
                        color: context.titleColor.withOpacity(.4.r),
                        fontSize: MyFonts.size13),
                  ),
                  Text(
                    'Advertise here',
                    style: getRegularStyle(
                        color: context.titleColor.withOpacity(.4.r),
                        fontSize: MyFonts.size13),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        AppAssets.promoteImage,
                        width: 14.w,
                        color: context.primaryColor,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        'Promoted by You',
                        style: getRegularStyle(
                            color: context.titleColor.withOpacity(.4.r),
                            fontSize: MyFonts.size13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.w),
                margin: EdgeInsets.all(AppConstants.allPadding),
                decoration: BoxDecoration(
                    color: context.whiteColor,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                          color: context.titleColor.withOpacity(.05),
                          spreadRadius: 0,
                          blurRadius: 12,
                          offset: const Offset(0, 0)),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.clockImage,
                          width: 32,
                        ),
                        padding8,
                        Text(
                          'History',
                          style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size16,
                          ),
                        ),
                      ],
                    ),
                    padding4,
                    Divider(
                      color: context.titleColor.withOpacity(.2.r),
                    ),
                    FutureBuilder<List<SearchResult>>(
                      future: SharedPrefHelper.loadSearchHistory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Or any loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final history = snapshot.data ?? [];
                          return history.isEmpty
                              ? Text(
                                  'No history Found',
                                  style: getMediumStyle(
                                    color: context.titleColor,
                                  ),
                                )
                              : ListView.separated(
                                  itemBuilder: (context, index) {
                                    final searchResult = history[index];
                                    return HistoryRow(
                                        title: searchResult.query);
                                  },
                                  separatorBuilder: (context, index) => Divider(
                                    color: context.titleColor.withOpacity(.2.r),
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: history.length,
                                );
                        }
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget searchEnabled() {
    return isLoading
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: ListView.builder(
              itemCount: 3,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(12.r),
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: context.titleColor, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: context.whiteColor,
                              )),
                          padding16,
                          ShimmerWidget(
                            height: 20.h,
                            width: 45.w,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : (result?.length ?? 0) <= 0
            ? Center(
                child: Text(
                'No place found!',
                style: getSemiBoldStyle(color: context.bodyTextColor),
              ))
            : Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.r),
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: result?.length ?? 0,
                      itemBuilder: (context, index) {
                        PlaceModel place = result![index];
                        return SuggestionContainer(
                          placeModel: place,
                          index: index,
                        );
                      }),
                ),
              );
  }
}
