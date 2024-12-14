import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import '../../../../commons/common_functions/service_enabled.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import '../../../../commons/common_widgets/custom_see_all_widget.dart';
import '../../../../models/place_model.dart';
import '../../../../routes/route_manager.dart';
import '../../location/location_controller/location_notifier_controller.dart';
import '../../restaurant/controller/places_controller.dart';
import '../../welcome/widgets/item_contaianer.dart';

class PlacesRow extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;
  final double? radius;
  final Function onLoadingCompleted;
  final bool isTopPlaces;

  const PlacesRow(
      {required this.categoryId,
      required this.onLoadingCompleted,
      required this.categoryName,
      this.isTopPlaces = false,
      // this.query,
      this.radius,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<PlacesRow> createState() => _PlacesRowState();
}

class _PlacesRowState extends ConsumerState<PlacesRow> {
  List<PlaceModel>? _places;
  String location = '';

  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getInitialPlaces();
  }

  _getInitialPlaces() async {
    if (ref.read(locationDetailNotifierCtr).locationDetail == null) {
      final locationEnabled = await serviceEnabled();
      if (!locationEnabled) {
        return;
      }
    }

    final ctr = ref.watch(placesControllerProvider.notifier);
    final PlacesAndLink result;
    if (widget.isTopPlaces) {
      result = await ctr.getTopPlace(limit: 10);
    } else if (widget.radius != null) {
      result = await ctr.getSearchPlacesOpenNowQueryWithoutState(
          radius: widget.radius);
    } else if (widget.categoryId == 'nearby') {
      result = await ctr.getSearchPlacesNearBy(
        radius: widget.radius ?? 500,
      );
    } else {
      result = await ctr.getSearchPlacesByCategories(
          categories: widget.categoryId, openNow: true);
    }
    widget.onLoadingCompleted();
    if (mounted) {
      setState(() {
        _places = result.places ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LocationNotifierController>(locationDetailNotifierCtr,
        (previous, next) {
      if (next.locationDetail != null) {
        _getInitialPlaces();
      }
    });
    return _places != null && (_places?.isEmpty ?? false)
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSeeAllWidget(
                    title: widget.categoryName,
                    buttonTextColor: context.primaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.placeslistScreen,
                          arguments: {
                            'categoriesId': widget.categoryId,
                            'categoryName': widget.categoryName,
                          });
                      // Navigator.pushNamed(context, AppRoutes.placesScreen,
                      //     arguments: {
                      //       'categoryIds': widget.categoryId,
                      //       'categoryName': widget.categoryName,
                      //       // 'query': '', //widget.query,
                      //       'radius': widget.radius,
                      //       'isTopPlace': widget.isTopPlaces
                      //     });
                    }),
                _places == null
                    ? SizedBox(
                        height: 260.h,
                        // width: 260.h,
                        child: PlaceListShimmer(
                          count: 5,
                          scrollDirection: Axis.horizontal,
                          cardWidth: 300.w,
                          cardRightMargin: 8.w,
                          leftMargin: true,
                          physics: const BouncingScrollPhysics(),
                        ),
                      )
                    : SizedBox(
                        height: 260.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: _places!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: index == 0 ? 20.w : 0),
                              child: ResturantItemContainer(
                                cardWidth: 300.w,
                                placeModel: _places![index],
                                rightMargin: 8.w,
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
  }
}
