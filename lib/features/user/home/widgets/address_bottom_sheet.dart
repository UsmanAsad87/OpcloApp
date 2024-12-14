import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:opclo/commons/common_widgets/custom_search_fields.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/user/location/location_controller/location_notifier_controller.dart';
import 'package:opclo/utils/loading.dart';
import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../location/location_controller/location_controller.dart';
import '../../location/model/location_detail.dart';
import '../../location/model/location_model.dart';
import '../../welcome/widgets/item_contaianer.dart';

class AddressBottomSheet extends StatefulWidget {
  final String address;
  final bool isSignUp;
  AddressBottomSheet({Key? key, required this.address, required this.isSignUp}) : super(key: key);

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheet();
}

class _AddressBottomSheet extends State<AddressBottomSheet> {
  bool isLoading = false;

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
          child: Stack(
            children: [
              Container(
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
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.address,
                                        style: getMediumStyle(
                                          color: context.titleColor,
                                          fontSize: MyFonts.size18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomSearchField(
                                  controller: searchController,
                                  hintText: 'Set location manually',
                                  verticalPadding: 14.r,
                                  iconColor: context.titleColor.withOpacity(.5),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  onFieldSubmitted: (value) {},
                                ),
                                Consumer(builder: (context, ref, child) {
                                  return ref.watch(authControllerProvider)
                                      ? LoadingWidget(
                                          color: context.primaryColor,
                                        )
                                      : InkWell(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                          onTap: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            LocationData? currentLocation =
                                                await locationCheck();
                                            if (currentLocation == null) {
                                              showSnackBar(context,
                                                  'Unable to get current location..');
                                              return null;
                                            }
                                            final detail = await ref
                                                .read(locationControllerProvider
                                                    .notifier)
                                                .fetchLocationDetailFromLatAndLng(
                                                    latitude: currentLocation
                                                        .latitude!,
                                                    longitude: currentLocation
                                                        .longitude!);

                                            ref
                                                .read(authControllerProvider
                                                    .notifier)
                                                .updateUserHomeAddress(
                                                    context: context,
                                                    address: detail,
                                                    isHomeAddress:
                                                        widget.address ==
                                                            'Set Home Address',
                                                    ref: ref,
                                                    isSignUp: widget.isSignUp);
                                            ref
                                                .read(locationDetailNotifierCtr)
                                                .setLocationDetail(null);
                                            setState(() {
                                              isLoading = false;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14.w,
                                                vertical: 10.h),
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
                                                      color:
                                                          context.primaryColor,
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
                                Consumer(builder: (context, ref, child) {
                                  return ref
                                      .watch(fetchLocationsProvider(
                                          searchController.text))
                                      .when(
                                          data: (locations) {
                                            return ListView.builder(
                                                itemCount: locations.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  final LocationModel location =
                                                      locations[index];
                                                  return LocationContainer(
                                                    location: location,
                                                    onTap: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      LocationDetails detail = await ref
                                                          .read(locationControllerProvider.notifier)
                                                          .fetchLocationDetail(id: location.id);
                                                      ref.read(authControllerProvider.notifier).updateUserHomeAddress(
                                                          context: context,
                                                          address: detail,
                                                          isHomeAddress: widget.address ==
                                                          'Set Home Address',
                                                          ref: ref,
                                                          isSignUp: widget.isSignUp);
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                    },
                                                  );
                                                });
                                          },
                                          error: (error, stackTrack) =>
                                              SizedBox(),
                                          loading: () => LoadingWidget(
                                                color: context.primaryColor,
                                              ));
                                }),
                              ])))),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.titleColor.withOpacity(.3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}

class LocationContainer extends ConsumerWidget {
  final LocationModel location;
  final Function() onTap;

  const LocationContainer({
    Key? key,
    required this.location,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: onTap,
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
