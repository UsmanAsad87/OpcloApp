import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opclo/commons/common_widgets/custom_search_fields.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/location/location_controller/location_notifier_controller.dart';
import 'package:opclo/features/user/location/model/location_detail.dart';
import 'package:opclo/utils/loading.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_providers/shared_pref_helper.dart';
import '../../../../commons/common_widgets/CustomTextFields.dart';
import '../../../../models/search_result_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../location_controller/location_controller.dart';
import '../model/location_model.dart';

class SearchLocationBottomSheet extends StatefulWidget {
  SearchLocationBottomSheet({Key? key}) : super(key: key);

  @override
  State<SearchLocationBottomSheet> createState() =>
      _SearchLocationBottomSheetState();
}

class _SearchLocationBottomSheetState extends State<SearchLocationBottomSheet> {
  List<String> _suggestions = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 700.h,
              margin: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: context.containerColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
            )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              height: 700.h,
              decoration: BoxDecoration(
                color: context.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(AppConstants.allPadding),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: context.titleColor,
                                  size: 18.r,
                                )),
                            padding24,
                            Text(
                              'Search Location',
                              style: getMediumStyle(
                                color: context.titleColor,
                                fontSize: MyFonts.size18,
                              ),
                            ),
                            CustomSearchField(
                              controller: searchController,
                              hintText: 'Search for your location',
                              verticalPadding: 14.r,
                              iconColor: context.titleColor.withOpacity(.5),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onFieldSubmitted: (value) {},
                            ),
                            Consumer(builder: (context, ref, child) {
                              return InkWell(
                                overlayColor: WidgetStateProperty.all(Colors.transparent),
                                onTap: () {
                                  ref.read(locationDetailNotifierCtr)
                                      .setLocationDetail(null);
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 10.h),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.my_location,
                                        color: context.primaryColor,
                                        size: 18.r,
                                      ),
                                      padding8,
                                      Text(
                                        'Use current location',
                                        style: getRegularStyle(
                                            color: context.primaryColor,
                                            fontSize: MyFonts.size13),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            Divider(
                              color: context.titleColor.withOpacity(.2),
                            ),
                            Visibility(
                              visible: searchController.text.isEmpty,
                              child: FutureBuilder<List<SearchResult>>(
                                future: SharedPrefHelper
                                    .loadSearchLocationHistory(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingWidget();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final history = snapshot.data ?? [];
                                    return history.length <= 0
                                        ? Center(
                                            child: Text(
                                              'No history Found',
                                              style: getMediumStyle(
                                                  color: context.titleColor,
                                                  fontSize: MyFonts.size13),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemBuilder: (context, index) {
                                              final searchResult =
                                                  history[index];
                                              return HistoryContainer(
                                                search: searchResult,
                                              );
                                            },
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: history.length,
                                          );
                                  }
                                },
                              ),
                            ),
                            Consumer(builder: (context, ref, child) {
                              return ref
                                  .watch(fetchLocationsProvider(
                                      searchController.text))
                                  .when(
                                      data: (locations) {
                                        print(locations.length);
                                        return ListView.builder(
                                            itemCount: locations.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final LocationModel location =
                                                  locations[index];
                                              return LocationContainer(
                                                location: location,
                                              );
                                            });
                                      },
                                      error: (error, stackTrack) =>
                                          SizedBox(),
                                      loading: () => LoadingWidget());
                            }),
                          ])))),
        ),
      ],
    );
  }
}

class LocationContainer extends ConsumerWidget {
  final LocationModel location;

  const LocationContainer({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () async {
        LocationDetails detail = await ref
            .read(locationControllerProvider.notifier)
            .fetchLocationDetail(id: location.id);
        ref.read(locationDetailNotifierCtr).setLocationDetail(detail);
        await SharedPrefHelper.saveSearchLocationHistory(
            SearchResult(
              placeId: location.id,
                query: location.name,
                timestamp: DateTime.now()));
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(
                Icons.access_time_outlined,
                color: context.titleColor,
                size: 18.r,
              ),
            ),
            padding8,
            SizedBox(
              width: 280.w,
              child: Text(
                location.name,
                style: getRegularStyle(
                    color: context.titleColor, fontSize: MyFonts.size13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryContainer extends ConsumerWidget {
  final SearchResult search;

  const HistoryContainer({Key? key, required this.search}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () async {
        LocationDetails detail = await ref
            .read(locationControllerProvider.notifier)
            .fetchLocationDetail(id: search.placeId!);
        ref.read(locationDetailNotifierCtr).setLocationDetail(detail);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(
                Icons.access_time_outlined,
                color: context.titleColor,
                size: 18.r,
              ),
            ),
            padding8,
            SizedBox(
              width: 280.w,
              child: Text(
                search.query,
                style: getRegularStyle(
                    color: context.titleColor, fontSize: MyFonts.size13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
