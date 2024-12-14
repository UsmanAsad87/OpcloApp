import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/check_conectivity.dart';
import '../../../../commons/common_functions/extract_next_page.dart';
import '../../../../commons/common_functions/service_enabled.dart';
import '../../../../models/place_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../location/location_controller/location_notifier_controller.dart';
import '../../location/views/no_location.dart';
import '../../no_internet/views/no_connection.dart';
import '../../restaurant/controller/places_controller.dart';
import '../../restaurant/widgets/location_widget.dart';
import '../../restaurant/widgets/no_place_open_body.dart';
import '../../welcome/widgets/item_contaianer.dart';

class PlacesChainScreen extends ConsumerStatefulWidget {
  final String categoryName;
  final String chainId;

  const PlacesChainScreen(
      {Key? key, required this.categoryName, required this.chainId})
      : super(key: key);

  @override
  ConsumerState<PlacesChainScreen> createState() => _PlacesQueryScreenState();
}

class _PlacesQueryScreenState extends ConsumerState<PlacesChainScreen> {
  ScrollController _scrollController = ScrollController();
  PermissionStatus? _permissionGranted;
  List<PlaceModel> _places = [];
  String? _nextPageLink;
  bool isLoading = false;
  bool locationEnabled = true;
  bool isInternet = true;

  @override
  void initState() {
    super.initState();
    _getInitialPlaces();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getInitialPlaces() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isInternet = await isInternetConnected();
      if (ref.read(locationDetailNotifierCtr).locationDetail == null) {
        locationEnabled = await serviceEnabled();
        if (!locationEnabled) {
          setState(() {});
          return;
        }
        setState(() {});
      }
      Location location = new Location();
      _permissionGranted = await location.hasPermission();
      PlacesAndLink result =
          await ref.read(placesControllerProvider.notifier).storeUsingChainId(
                chainId: widget.chainId,
              );
      setState(() {
        _places = result.places ?? [];
        _nextPageLink = extractNextPageLink(result.link);
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('Calling ...');
      if (_nextPageLink != null) {
        setState(() {
          isLoading = true;
        });
        _loadNextPage();
      }
    }
  }

  void _loadNextPage() async {
    PlacesAndLink result = await ref
        .read(placesControllerProvider.notifier)
        .getNextPage(nextPage: _nextPageLink!);
    setState(() {
      _places.addAll(result.places ?? []);
      _nextPageLink = extractNextPageLink(result.link);
      isLoading = false;
    });
  }

  // /// get Next Page Page.
  // String? extractNextPageLink(List<String>? links) {
  //   if (links == null || links.isEmpty) {
  //     return null;
  //   }
  //   final link = links.firstWhere(
  //     (element) => element.contains('rel="next"'),
  //     orElse: () => '',
  //   );
  //   final startIndex = link.indexOf('<');
  //   final endIndex = link.indexOf('>');
  //   if (startIndex != -1 && endIndex != -1) {
  //     return link.substring(startIndex + 1, endIndex);
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return !isInternet
        ? NoConnection(
            onTap: () {
              setState(() {
                isInternet = true;
                locationEnabled = true;
              });
              _getInitialPlaces();
            },
          )
        : locationEnabled
            ? Scaffold(
                backgroundColor: context.whiteColor,
                appBar: AppBar(
                  backgroundColor: context.whiteColor,
                  elevation: 0,
                  leading: InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: context.titleColor,
                    ),
                  ),
                  title: Text(
                    widget.categoryName,
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size16),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                ),
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0.h),
                      child:
                          // _places.isEmpty
                          //     ? PlaceListShimmer(count: 5)
                          //     :
                          Column(
                        children: [
                          ref.watch(placesControllerProvider)
                              ? PlaceListShimmer(count: 5)
                              : _permissionGranted == PermissionStatus.denied
                                  ? LocationWidget(onTap: () {
                                      AppSettings.openAppSettings(
                                          type: AppSettingsType.location);
                                    })
                                  : _places.length <= 0
                                      ? NoPlaceOpenBody(
                                          onTap: () {
                                            _getInitialPlaces();
                                          },
                                        )
                                      : ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _places.length,
                                          itemBuilder: (context, index) {
                                            return ResturantItemContainer(
                                              placeModel: _places[index],
                                            );
                                          },
                                        ),
                          isLoading ? PlaceListShimmer(count: 2) : SizedBox()
                        ],
                      )),
                ),
              )
            : NoLocation(onTap: () async {
                final isEnable = await enableService();
                if (isEnable) {
                  _getInitialPlaces();
                }
              });
  }
}
