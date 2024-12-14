import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/home/widgets/place_name_and_location_container.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/loading.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../main_menu/controller/main_menu_controller.dart';
import '../../profile/profile_extended/add_note/views/add_location.dart';
import '../../restaurant/controller/places_controller.dart';

class BottomSheetHomePage extends ConsumerStatefulWidget {
  const BottomSheetHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomSheetHomePage> createState() =>
      _BottomSheetHomePageState();
}

class _BottomSheetHomePageState extends ConsumerState<BottomSheetHomePage> {
  // late DraggableScrollableController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels <= 0) {
      setState(() {
        _isAtTop = true;
      });
    }
  }

  final _bsbController = BottomSheetBarController();

  final ScrollController _scrollController = ScrollController();
  bool _isAtTop = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierCtr).userModel;
    return SlidingBox(
        minHeight: 30,
        maxHeight: 600.h,
        draggableIconVisible: false,
        collapsed: true,
        onBoxSlide: (d) {
          setState(() {
            _isAtTop = false;
          });
        },
        style: BoxStyle.shadow,
        body: Container(
          height: 700.h,
          decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.bodyTextColor,
                  spreadRadius: 30,
                  blurRadius: 12,
                )
              ]),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 5.h,
                  width: 50.w,
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: MyColors.darkLightTextColor.withOpacity(0.5),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Access',
                      style: getSemiBoldStyle(
                        color: context.titleColor,
                        fontSize: MyFonts.size18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        user == null
                            ? ref.watch(mainMenuProvider).setIndex(4)
                            : _showSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_outlined,
                          size: 23.r,
                          color: context.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: user == null
                    ? Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Text(
                          'Login to add quickAccess',
                          style: getMediumStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size12,
                          ),
                        ),
                      )
                    : ref.watch(quickAccessStreamProvider(context)).when(
                          data: (placesId) {
                            return placesId.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(top: 12.h),
                                    child: Text(
                                      'No placed added yet',
                                      style: getMediumStyle(
                                        color: context.titleColor,
                                        fontSize: MyFonts.size12,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    controller: _scrollController,
                                    physics: _isAtTop
                                        ? NeverScrollableScrollPhysics()
                                        : BouncingScrollPhysics(),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: placesId.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final String placeId = placesId[index];
                                        return ref
                                            .watch(
                                                getPlacesByIdProvider(placeId))
                                            .when(
                                              data: (place) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: index ==
                                                              placesId.length -
                                                                  1
                                                          ? 120.h
                                                          : 0),
                                                  child:
                                                      PlaceNameAndLocationContainerQuick(
                                                    title: place!.placeName,
                                                    subTitle:
                                                        place.locationName,
                                                    place: place,
                                                  ),
                                                );
                                              },
                                              error: (error, stack) {
                                                return SizedBox();
                                              },
                                              loading: () => LoadingWidget(),
                                            );
                                      },
                                    ),
                                  );
                          },
                          error: (error, stack) => SizedBox(),
                          loading: () => LoadingWidget(),
                        ),
              ),
            ],
          ),
        ));
  }

  void _showSheet(context) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return AddLocation(
            isQuickAccess: true,
          );
        });
  }
}
