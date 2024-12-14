import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../commons/common_imports/common_libs.dart';

class MapScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  MapScreen({Key? key, this.latitude, this.longitude});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _latitude = 0.0, _longitude = 0.0;
  BitmapDescriptor? _customMarkerIcon;

  initialize() {
    _latitude = widget.latitude ?? 34.0151;
    _longitude = widget.longitude ?? 71.5249;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
    _loadCustomMarker();
  }

  void _loadCustomMarker() async {
    _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(60.w, 60.h),
      ),
      AppAssets.mapLocationIconImage,
    );
    setState(() {
      // _customMarkerIcon = _customMarkerIcon!.copyWith(size: Size(2, 2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.whiteColor,
        body: Column(
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
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    markers: {
                      if (_customMarkerIcon != null)
                        Marker(
                          markerId: const MarkerId('locate'),
                          zIndex: 1,
                          onDragEnd: (LatLng newPosition) {
                            setState(() {
                              _latitude = newPosition.latitude;
                              _longitude = newPosition.longitude;
                            });
                          },
                          icon: _customMarkerIcon!,
                          position: LatLng(_latitude, _longitude),
                        )
                    },
                    circles: {
                      Circle(
                          circleId: CircleId('circle_around_marker'),
                          center: LatLng(_latitude, _longitude),
                          radius: 50,
                          fillColor: context.primaryColor.withOpacity(.2),
                          strokeWidth: 1,
                          strokeColor: context.titleColor.withOpacity(.4)),
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(_latitude, _longitude), zoom: 18.478),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: CustomButton(
                          onPressed: () async {
                            // final googleMapsUrl =
                            //     'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude';
                            final googleMapsUrl = Uri.parse('https://www.google.com/maps?q=$_latitude,$_longitude');
                            // Uri.parse('geo:$_latitude,$_longitude?q=$_latitude,$_longitude');

                            Share.share(googleMapsUrl.toString());
                            // });
                          },
                          buttonWidth: 250.w,
                          buttonText: 'Share Location'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
