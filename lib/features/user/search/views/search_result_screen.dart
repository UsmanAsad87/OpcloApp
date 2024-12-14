import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/search/controller/filter_notifier_controller.dart';
import 'package:opclo/features/user/search/widgets/no_places_body.dart';
import 'package:opclo/features/user/welcome/widgets/item_contaianer.dart';
import '../../../../commons/common_functions/service_enabled.dart';
import '../../../../commons/common_widgets/custom_search_fields.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../models/place_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../location/location_controller/location_notifier_controller.dart';
import '../../location/views/no_location.dart';
import '../../main_menu/controller/conectivity_notifier.dart';
import '../../no_internet/views/no_connection.dart';
import '../controller/search_limit.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/status_container.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final String query;

  const SearchResultScreen({Key? key, required this.query}) : super(key: key);

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  final ScrollController _scrollController = ScrollController();
  bool locationEnabled = true;

  @override
  void initState() {
    final filterCtr = ref.read(filterNotifierCtr);
    filterCtr.search(ref: ref, query: widget.query, context: context);
    filterCtr.searchController.text = widget.query;
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        FocusScope.of(context).unfocus();
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        filterCtr.loadNextPage(ref: ref);
      }
    });
    enableLocation();
  }

  enableLocation() async {
    if (ref.read(locationDetailNotifierCtr).locationDetail == null) {
      locationEnabled = await enableService();
      if (!locationEnabled) {
        setState(() {});
        return;
      }
      setState(() {});
    }
  }

  final filters = [
    'Filter',
    'Open Now',
    'Nearest to you',
  ];

  @override
  Widget build(BuildContext context) {
    final filterCtr = ref.watch(filterNotifierCtr);
    bool isInternet = ref.read(connectivityProvider);
    return !isInternet
        ? NoConnection(
            isPop: false,
            onTap: () async {
              // isInternet = await isInternetConnected();
              isInternet = ref.read(connectivityProvider);
              if (isInternet) {
                setState(() {});
              } else {
                showToast(
                    msg: 'No Connection yet',
                    backgroundColor: context.primaryColor.withOpacity(.2));
              }
            },
          )
        : !locationEnabled
            ? NoLocation(onTap: () async {
                final isEnable = await enableService();
                setState(() {
                  locationEnabled = isEnable;
                });
              })
            : Scaffold(
                backgroundColor: context.whiteColor,
                body: SafeArea(
                  child: Column(
                    children: [
                      Consumer(
                          builder: (
                              context,
                              ref,
                              child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.allPadding),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.containerColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: CustomSearchField(
                              controller: filterCtr.searchController,
                              hintText: filterCtr.isLoading
                                  ? widget.query
                                  : 'Search restaurants, stores & more',
                              icon: InkWell(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: context.titleColor,
                                  size: 22.r,
                                ),
                              ),
                              verticalMargin: 0,
                              borderSide: BorderSide.none,
                              onChanged: (search) async {
                                filterCtr.setSearchController(search);
                                filterCtr.applyFilter(
                                    ref: ref, context: context, isPop: false);
                              },
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 50.h,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          // controller: _scrollController,
                          //shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  showFilterBottomSheet();
                                }
                                if (index == 1) {
                                  if (filterCtr.selectedStatus?.value !=
                                      'true') {
                                    filterCtr
                                        .selectStatusOption(statusOption[1]);
                                  } else {
                                    filterCtr
                                        .selectStatusOption(statusOption[0]);
                                  }
                                  filterCtr.applyFilter(
                                      ref: ref, context: context, isPop: false);
                                }
                                if (index == 2) {
                                  filterCtr.setNearBy(!filterCtr.nearBy);
                                  filterCtr.applyFilter(
                                      ref: ref, context: context, isPop: false);
                                }
                              },
                              child: Container(
                                height: 10.h,
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.w, horizontal: 10.h),
                                margin: EdgeInsets.fromLTRB(
                                    index == 0 ? 28 : 20, 8, 0, 8),
                                decoration: BoxDecoration(
                                    color: index == 1 &&
                                            filterCtr.selectedStatus?.value ==
                                                'true'
                                        ? context.primaryColor
                                        : index == 2 && filterCtr.nearBy
                                            ? context.primaryColor
                                            : context.containerColor,
                                    borderRadius: BorderRadius.circular(50.r)),
                                child: Row(
                                  children: [
                                    if (index == 0)
                                      Padding(
                                        padding: EdgeInsets.only(right: 4.w),
                                        child: Icon(
                                          Icons.filter_alt_outlined,
                                          color: context.titleColor
                                              .withOpacity(.4.r),
                                        ),
                                      ),
                                    Center(
                                      child: Text(
                                        filters[index],
                                        style: getSemiBoldStyle(
                                            color: index == 1 &&
                                                    filterCtr.selectedStatus
                                                            ?.value ==
                                                        'true'
                                                ? context.whiteColor
                                                : index == 2 && filterCtr.nearBy
                                                    ? context.whiteColor
                                                    : context.titleColor
                                                        .withOpacity(.4.r),
                                            fontSize: MyFonts.size12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: filterCtr.isLoading
                            ? Padding(
                              padding: EdgeInsets.all(16.w),
                              child: const PlaceListShimmer(
                                  count: 5,
                                  physics: BouncingScrollPhysics(),
                                ),
                            )
                            : (filterCtr.result?.length ?? 0) <= 0
                                ? const NoPlaceWidget()
                                : SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            // controller: _scrollController,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                filterCtr.result?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              PlaceModel place =
                                                  filterCtr.result![index];
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: AppConstants
                                                        .horizontalPadding),
                                                child: ResturantItemContainer(
                                                  placeModel: place,
                                                  onTap: () {
                                                    final isPrem =
                                                        ref.read(authNotifierCtr).userModel?.subscriptionIsValid ?? false;
                                                    if (!isPrem) {
                                                       SearchLimiter.incrementSearchCount();
                                                    }
                                                    Navigator.pushNamed(context, AppRoutes.detailResturantScreen,
                                                        arguments: {'placeModel': place});
                                                  },
                                                ),
                                              );
                                            }),
                                        if (filterCtr.nextPageLoading)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w),
                                            child: const PlaceListShimmer(
                                              count: 5,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                      )
                    ],
                  ),
                ),
              );
  }

  showFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const FilterBottomSheet();
        });
  }
}
