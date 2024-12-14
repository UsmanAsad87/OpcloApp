import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_shimmer/loading_images_shimmer.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_card_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/home/widgets/address_bottom_sheet.dart';
import 'package:opclo/features/user/home/widgets/place_name_and_location_container.dart';
import 'package:opclo/features/user/main_menu/controller/main_menu_controller.dart';
import 'package:opclo/features/user/restaurant/controller/places_controller.dart';
import 'package:opclo/models/like_group_model.dart';
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/loading.dart';
import '../../../../commons/common_functions/open_map.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/custom_search_fields.dart';
import '../../../../commons/common_widgets/custom_see_all_widget.dart';
import '../../../../models/favorite_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../home/widgets/work_and_home_tile.dart';
import '../../welcome/widgets/item_contaianer.dart';
import '../controller/like_controller.dart';
import '../widgets/add_address_dailog.dart';

class Favorites extends ConsumerStatefulWidget {
  final bool pop;

  const Favorites({super.key, required this.pop});

  @override
  ConsumerState<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends ConsumerState<Favorites> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController homeCtr = TextEditingController();
  final TextEditingController workCtr = TextEditingController();

  String selectedValue = 'All Results';
  FocusNode searchFocusNode = FocusNode();
  bool isSearchActive = false;
  bool openFilter = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to the searchFocusNode
    searchFocusNode.addListener(() {
      setState(() {
        isSearchActive = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    homeCtr.dispose();
    workCtr.dispose();
    super.dispose();
  }

  void activateSearch() {
    searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierCtr).userModel;
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: context.whiteColor,
        elevation: 0,
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            widget.pop
                ? Navigator.pop(context)
                : ref.read(mainMenuProvider).setIndex(0);
            // Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'Favorites',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.containerColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: CustomSearchField(
                      controller: searchController,
                      hintText: 'Search favorites...',
                      verticalMargin: 0,
                      borderSide: BorderSide.none,
                      focusNode: searchFocusNode,
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Sorted by : ',
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size15),
                      ),
                      DropdownButton<String>(
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            openFilter = newValue == 'Closed' ? false : true;
                            selectedValue = newValue!;
                          });
                        },
                        items: <String>['All Results', 'Open Now', 'Closed']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        style: getSemiBoldStyle(
                            color: context.titleColor.withOpacity(.5),
                            fontSize: MyFonts.size15),
                        icon: Icon(Icons.keyboard_arrow_down_outlined,
                            color: context.primaryColor),
                        underline: const SizedBox(),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            searchWidget(),
            Visibility(
                visible: !isSearchActive,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.horizontalPadding),
                        child: Column(
                          children: [
                            user?.homeAddress != null
                                ? InkWell(
                                    onTap: () {
                                      openMap(
                                          lat: user!.homeAddress!.latitude,
                                          lng: user.homeAddress!.longitude);
                                    },
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    child: WorkAndHomeTile(
                                        title: 'Home',
                                        subtitle: user?.homeAddress?.name,
                                        iconPath: AppAssets.home),
                                  )
                                : InkWell(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return AddressBottomSheet(
                                              address: 'Set Home Address',
                                              isSignUp: false,
                                            );
                                          });
                                    },
                                    child: const WorkAndHomeTile(
                                        title: 'Home',
                                        subtitle: 'Set once and go',
                                        iconPath: AppAssets.home),
                                  ),
                            user?.workAddress != null
                                ? InkWell(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    onTap: () {
                                      openMap(
                                          lat: user!.workAddress!.latitude,
                                          lng: user.workAddress!.longitude);
                                    },
                                    child: WorkAndHomeTile(
                                        title: 'Work',
                                        subtitle: user?.workAddress?.name,
                                        iconPath: AppAssets.workPerson),
                                  )
                                : InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return AddressBottomSheet(
                                              address: 'Set Work Address',
                                              isSignUp: false,
                                            );
                                          });
                                    },
                                    child: const WorkAndHomeTile(
                                        title: 'Work',
                                        subtitle: 'Set once and go',
                                        iconPath: AppAssets.workPerson)),
                            padding12,
                          ],
                        ),
                      ),
                      Consumer(builder: (context, ref, child) {
                        return ref.watch(favoritesStreamProvider).when(
                              data: (placesId) {
                                Set<String> groupIds = placesId
                                    .map((place) => place.groupId)
                                    .toSet();
                                return ref.watch(getAllLikeGroupsProvider).when(
                                      data: (groups) {
                                        return groups.isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No Group List Found',
                                                  style: getSemiBoldStyle(
                                                    color: context.titleColor,
                                                    fontSize: MyFonts.size16,
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount: groups.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  LikeGroupModel likeGroup =
                                                      groups[index];
                                                  if (!groupIds
                                                      .contains(likeGroup.id)) {
                                                    return const SizedBox.shrink();
                                                  }
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.h),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: AppConstants
                                                                .horizontalPadding,
                                                          ),
                                                          child:
                                                              CustomSeeAllWidget(
                                                            title: likeGroup
                                                                .groupName,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onTap: () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                AppRoutes
                                                                    .favouriteListScreen,
                                                                arguments: {
                                                                  'groupId':
                                                                      likeGroup
                                                                          .id
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        likePlace(
                                                            ref: ref,
                                                            groupId:
                                                                likeGroup.id),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                      },
                                      error: (error, stackTrace) => const SizedBox(),
                                      loading: () => Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                AppConstants.horizontalPadding),
                                        child: Column(
                                          children: [
                                            CustomSeeAllWidget(
                                                title: '',
                                                padding: EdgeInsets.zero,
                                                onTap: () {}),
                                            PlaceCardShimmer(),
                                          ],
                                        ),
                                      ),
                                    );
                              },
                              error: (error, stackTrace) => const SizedBox(),
                              loading: () => Text(''), //const PlaceCardShimmer(),
                            );
                      }),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  searchWidget() {
    return Visibility(
      visible: isSearchActive,
      child: Consumer(builder: (context, ref, child) {
        return ref.watch(favoritesStreamProvider).when(
              data: (placesId) {
                return Padding(
                  padding: EdgeInsets.all(AppConstants.padding),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: placesId.length,
                    itemBuilder: (context, index) {
                      return ref
                          .watch(getPlacesByIdProvider(placesId[index].fsqId))
                          .when(
                            data: (place) {
                              if (place!.placeName.toLowerCase().contains(
                                      searchController.text.toLowerCase()) &&
                                  (place.isOpen == openFilter ||
                                      selectedValue == 'All Results')) {
                                return PlaceNameAndLocationContainer(
                                  title: place.placeName,
                                  subTitle: place.locationName,
                                  place: place,
                                  horizontalMargin: 0,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                            error: (error, stackTrace) => const SizedBox(),
                            loading: () => LoadingWidget(
                              color: context.primaryColor,
                            ),
                          );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => SizedBox(),
              loading: () => LoadingWidget(),
            );
      }),
    );
  }

  likePlace({required WidgetRef ref, required String groupId}) {
    return ref.watch(favoritesStreamProvider).when(
        data: (placesId) {
          List<FavoriteModel> filterPlaces =
              placesId.where((place) => place.groupId == groupId).toList();
          return filterPlaces.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 18.h),
                  child: Text(
                    'No Favorites (yet!)',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size16),
                  ),
                )
              : Swiper(
                  itemWidth: 600.w,
                  itemHeight: 300.h,
                  loop: false,
                  duration: 200,
                  scrollDirection: Axis.horizontal,
                  itemCount: filterPlaces.length,
                  itemBuilder: (context, index) {
                    return ref
                        .watch(getPlacesByIdProvider(filterPlaces[index].fsqId))
                        .when(
                            data: (place) {
                              return ResturantItemContainer(
                                placeModel: place,
                              );
                            },
                            error: (error, stackTrace) => const SizedBox(),
                            loading: () => const PlaceCardShimmer());
                  },
                  layout: SwiperLayout.TINDER,
                );
        },
        error: (error, stackTrace) => const SizedBox(),
        loading: () => const PlaceCardShimmer());
  }
}
