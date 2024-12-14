import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/search/controller/filter_notifier_controller.dart';
import 'package:opclo/features/user/search/widgets/sort_container.dart';
import 'package:opclo/features/user/search/widgets/status_container.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../commons/common_widgets/custom_search_fields.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../location/location_controller/location_notifier_controller.dart';
import '../../location/views/search_location_bootom_sheet.dart';
import 'custom_slider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  TextEditingController searchController2 = TextEditingController();
  bool isClear = false;

  @override
  Widget build(BuildContext context) {
    final filterCtr = ref.watch(filterNotifierCtr);
    return Stack(children: [
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: context.titleColor,
                        ),
                      ),
                      Text(
                        'Filters',
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size18),
                      ),
                      padding20,
                    ],
                  ),
                  padding16,
                  InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          enableDrag: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return SearchLocationBottomSheet();
                          });
                    },
                    child: CustomContainer(
                      header: 'Near',
                      child: Consumer(builder: (context, ref, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: MyColors.textFieldBackColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomSearchField(
                            controller: searchController2,
                            verticalPadding: 0,
                            verticalMargin: 0,
                            borderSide: BorderSide.none,
                            hintColor: context.bodyTextColor,
                            enable: false,
                            hintText: ref
                                        .watch(locationDetailNotifierCtr)
                                        .locationDetail !=
                                    null
                                ? ref
                                    .watch(locationDetailNotifierCtr)
                                    .locationDetail!
                                    .name
                                : 'Current Location',
                            //'current Location',
                            icon: Icon(
                              Icons.location_on,
                              color: context.bodyTextColor,
                              size: 19.r,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  padding16,
                  CustomContainer(
                    header: 'Sort by:',
                    child: SortContainer(),
                  ),
                  padding16,
                  CustomContainer(header: 'Status:', child: StatusContainer()),
                  padding16,
                  CustomContainer(
                    header: 'Distance:',
                    child: CustomSlider(
                      onChange: (rangeSliderValues) {
                        filterCtr
                            .setDistanceValue(rangeSliderValues.lowerValue);
                      },
                      leftThumbSlider: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.h,
                          horizontal: 4.w,
                        ),
                        height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border:
                              Border.all(color: MyColors.white, width: 4.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0.sp,
                              blurRadius: 8.sp,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 3.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2.r)),
                            ),
                            Container(
                              height: 3.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2.r)),
                            ),
                            Container(
                              height: 3.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      selectedValue: filterCtr.distance ?? 0,
                      max: 100,
                      min: 0,
                      selectedColor: context.primaryColor,
                      deselectedColor: MyColors.black.withOpacity(.1),
                      barHeight: 8,
                    ),
                  ),
                  padding16,
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          isLoading: isClear && filterCtr.isLoading,
                          loadingColor: context.whiteColor,
                          onPressed: () {
                            setState(() {
                              isClear = true;
                            });
                            filterCtr.search(
                              ref: ref, context: context,
                            );
                            filterCtr.disposeAll(context: context);
                          },
                          buttonText: 'Clear all',
                        ),
                      ),
                      padding12,
                      Expanded(
                        child: CustomOutlineButton(
                          isLoading: !isClear && filterCtr.isLoading,
                          onPressed: () {
                            filterCtr.applyFilter(
                              ref: ref,
                              context: context,
                            );
                          },
                          buttonText: 'Apply',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

class CustomContainer extends StatelessWidget {
  final String header;
  final Widget child;

  const CustomContainer({Key? key, required this.header, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: context.primaryColor.withOpacity(.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: getSemiBoldStyle(
                color: context.titleColor, fontSize: MyFonts.size14),
          ),
          padding8,
          child
        ],
      ),
    );
  }
}
