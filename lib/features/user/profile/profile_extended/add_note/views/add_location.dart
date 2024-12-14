import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:opclo/utils/loading.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/custom_search_fields.dart';
import '../../../../../../models/place_model.dart';
import '../../../../restaurant/controller/places_controller.dart';
import '../controller/select_location.dart';
import '../widgets/add_location_container.dart';
import 'dart:io' show Platform;


class AddLocation extends StatefulWidget {
  final bool isQuickAccess;

  AddLocation({Key? key, required this.isQuickAccess}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  TextEditingController searchController = TextEditingController();
  List<PlaceModel>? result;
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
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
            ),
          )),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              height: Platform.isIOS?730.h:700.h,
              // margin: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: context.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: context.titleColor,
                                    size: 20.r,
                                  )),
                              Consumer(builder: (context, ref, child) {
                                return GestureDetector(
                                  onTap: () {
                                    if (widget.isQuickAccess) {
                                      final selectedPlace = ref
                                          .read(selectedLocationProvider)
                                          .selectedPlace;
                                      if (selectedPlace != null) {
                                        ref
                                            .read(
                                                authControllerProvider.notifier)
                                            .updateQuickAccess(
                                                context: context,
                                                newId: selectedPlace.fsqId);
                                      }
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Done',
                                    style: getMediumStyle(
                                        color: context.primaryColor,
                                        fontSize: MyFonts.size16),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        Consumer(builder: (context, ref, child) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.allPadding),
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.containerColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: CustomSearchField(
                                controller: searchController,
                                hintText: 'Search restaurants, stores & more',
                                verticalMargin: 0,
                                borderSide: BorderSide.none,
                                onChanged: (search) async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final placesAndLink = await ref
                                      .read(placesControllerProvider.notifier)
                                      .getSearchPlacesQuery(query: search, context: context);
                                  result = placesAndLink.places;
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                        isLoading
                            ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 30.h),
                              child: LoadingWidget(
                                  size: 20.r,
                                  color: context.primaryColor,
                                ),
                            )
                            : SizedBox(
                                height: 500.h,
                                child: (result?.length ?? 0) <= 0
                                    ? Center(child: Text('Search'))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        controller: _scrollController,
                                        itemCount: result?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          PlaceModel place = result![index];
                                          return AddLocationContainer(
                                            placeModel: place,
                                          );
                                        }),
                              )
                      ],
                    ),
                  ),
                  Consumer(builder: (context, ref, child) {
                    return ref.watch(authControllerProvider)
                        ? Container(
                        decoration: BoxDecoration(
                          color: context.titleColor.withOpacity(.3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                        ),
                            child: Center(child: CircularProgressIndicator()))
                        : SizedBox();
                  })
                ],
              )))
    ]);
  }
}
