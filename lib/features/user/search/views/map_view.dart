import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/location/views/no_location.dart';
import 'package:opclo/features/user/search/views/map_screen.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_shimmer/loading_images_shimmer.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';

class MapView extends StatefulWidget {
  final double? lat;
  final double? lng;
  const MapView({Key? key, this.lat, this.lng}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool isLoading = true;
  bool _serviceEnabled = false;
  LocationData? _locationData;

  locationCheck({required bool request}) async {
    setState(() {
      isLoading = true;
    });
    Location location = new Location();
    //  bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      if (request) {
        _serviceEnabled = await location.requestService();
      }
      if (!_serviceEnabled) {
        setState(() {
          isLoading = false;
        });
        return;
      }
    }
     if (widget.lng == null && widget.lat == null) {
       _locationData = await location.getLocation();
     }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    locationCheck(request: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return isLoading
        ? SafeArea(
          child: Scaffold(
              backgroundColor: context.whiteColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100.h,
                    color: context.primaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.allPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.close,
                              color: context.whiteColor,
                            ),
                          ),
                          Text('Opclo',
                              style: getSemiBoldStyle(
                                  color: context.whiteColor,
                                  fontSize: MyFonts.size18)),
                          padding16,
                        ],
                      ),
                    ),
                  ),
                  //
                  // ShimmerWidget(
                  //   height: 150.h,
                  //   highlightColor: context.primaryColor,
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: ShimmerWidget(
                      height: 40.h,
                      width: 200,
                      highlightColor: context.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
        )
        : _serviceEnabled
            ? MapScreen(
                latitude: widget.lat ?? _locationData?.latitude,
                longitude: widget.lng ?? _locationData?.longitude,
              )
            : NoLocation(
                onTap: () {
                  locationCheck(request: true);
                },
              );
  }
}
