import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../utils/constants/font_manager.dart';


/// a range slider that fits the box it is given.
/// colors can be customized. Also, if thumbSlider,
/// leftLabel, or rightLabel is given, there is
/// greater option for customizability.
class CustomSlider extends StatefulWidget {
  //expect "lowerValue" and "upperValue" as keys
  final Function(RangeSliderValues) onChange;
  final int min;
  final int max;
  final int selectedValue; // lower value that is selected.
  // final int upperValue; // higher number that is selected
  final int barHeight; // height of the containers between thumb sliders
  final Color selectedColor;
  final Color deselectedColor;
  final Widget? leftThumbSlider; //by default, it is a blue circle.
  // final Widget? rightThumbSlider; //by default, it is a blue circle.
  final Widget? leftLabel; //by default, it is blue text
  final Widget? rightLabel; //by default, it is blue text

  const CustomSlider(
      {Key? key,
      required this.onChange,
      this.max = 10,
      this.min = 0,
      this.selectedValue = 0,
      // this.upperValue = 10,
      this.barHeight = 2,
      this.selectedColor = Colors.blue,
      this.deselectedColor = Colors.grey,
      this.leftThumbSlider,
      // this.rightThumbSlider,
      this.leftLabel,
      this.rightLabel})
      : super(key: key);

  @override
  CustomSliderState createState() => CustomSliderState();
}

class CustomSliderState extends State<CustomSlider> {
  late int selectedValue = 0;

  // late int upperValue = 0;
  late Widget leftThumbSlider;

  // late Widget rightThumbSlider;
  late Widget leftLabel;
  late Widget rightLabel;
  int? dragStartVal;

  @override
  void initState() {
    if (widget.leftThumbSlider != null) {
      leftThumbSlider = widget.leftThumbSlider!;
    } else {
      leftThumbSlider =
          getDefaultThumbSlider(key: const Key("leftThumbSlider"));
    }
    // if (widget.rightThumbSlider != null) {
    //   rightThumbSlider = widget.rightThumbSlider!;
    // } else {
    //   rightThumbSlider =
    //       getDefaultThumbSlider(key: const Key("rightThumbSlider"));
    // }
    if (widget.leftLabel != null) {
      leftLabel = widget.leftLabel!;
    } else {
      leftLabel = getDefaultLabel();
    }
    if (widget.rightLabel != null) {
      rightLabel = widget.rightLabel!;
    } else {
      rightLabel = getDefaultLabel(isLeft: false);
    }
    selectedValue = widget.selectedValue;
    // upperValue = widget.upperValue;
    super.initState();
  }

  Widget getDefaultThumbSlider({Key? key}) {
    return Container(
      key: key,
      height: 20.sp,
      width: 20.sp,
      decoration: BoxDecoration(
        color: widget.selectedColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
      ),
    );
  }

  void onChange() {
    widget.onChange(RangeSliderValues(
      lowerValue: selectedValue,
    ));
  }

  Widget getDefaultLabel({bool isLeft = true}) {
    return SizedBox(
      width: 30.sp,
      child: Center(
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            // isLeft ? "\$$lowerValue" : "\$$upperValue",
            isLeft ? "\$$selectedValue" : "uppervalue",
            style: TextStyle(
              color: widget.selectedColor,
              fontSize: MyFonts.size12,
              fontWeight: FontWeight.w700,
              fontFamily: 'mulish_bold',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///unselected bar before first thumb
              // Expanded(
              //   flex: lowerValue - widget.min,
              //   child: Column(
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //             color: widget.deselectedColor,
              //             borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(30.sp),
              //                 topLeft: Radius.circular(30.sp))),
              //         height: widget.barHeight * 1,
              //       ),
              //       SizedBox(height: 10.h),
              //       Text('')
              //     ],
              //   ),
              // ),

              ///Selected bar
              Expanded(
                flex: selectedValue - widget.min,
                child: Column(
                  children: [
                    Container(
                      height: widget.barHeight * 1,
                      decoration: BoxDecoration(
                        color: widget.selectedColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.sp),
                          topLeft: Radius.circular(30.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text('')
                  ],
                ),
              ),

              ///First thumb
              Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onHorizontalDragStart: (DragStartDetails details) {
                      dragStartVal = selectedValue;
                    },
                    onHorizontalDragEnd: (DragEndDetails details) {
                      dragStartVal = null;
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                      double totalDistanceTraveled = details.localPosition.dx;
                      double distanceBetweenValues =
                          constraints.maxWidth / (widget.max - widget.min);
                      int numSteps =
                          (totalDistanceTraveled / distanceBetweenValues)
                              .round();
                      int beforeChange = selectedValue;
                      if (dragStartVal != null) {
                        setState(() {
                          selectedValue = dragStartVal! + numSteps;
                          if (selectedValue < widget.min)
                            selectedValue = widget.min;
                          if (selectedValue >= widget.max) {
                            selectedValue = widget.max - 1;
                          }
                        });
                        if (beforeChange != selectedValue) onChange();
                      }
                    },
                    child: leftThumbSlider,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    selectedValue.toString(),
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size12),
                  )
                  // CommonWidgets.customTextView(
                  //     text: selectedValue.toString(),
                  //     color: MyColors.textColor, fontSize: MyFonts.fonts12,
                  //     fontWeight: FontWeight.w600)
                ],
              ),

              //
              // ///Second thumb
              // Column(
              //   children: [
              //     GestureDetector(
              //       onHorizontalDragStart: (DragStartDetails details) {
              //         dragStartVal = upperValue;
              //       },
              //       onHorizontalDragEnd: (DragEndDetails details) {
              //         dragStartVal = null;
              //       },
              //       onHorizontalDragUpdate: (DragUpdateDetails details) {
              //         double totalDistanceTraveled = details.localPosition.dx;
              //         double distanceBetweenValues =
              //             constraints.maxWidth / (widget.max - widget.min);
              //         int numSteps =
              //         (totalDistanceTraveled / distanceBetweenValues)
              //             .round();
              //         int beforeChange = upperValue;
              //         if (dragStartVal != null) {
              //           setState(() {
              //             upperValue = dragStartVal! + numSteps;
              //             if (upperValue > widget.max) upperValue = widget.max;
              //             if (upperValue <= lowerValue) {
              //               upperValue = lowerValue + 1;
              //             }
              //           });
              //           if (beforeChange != upperValue) onChange();
              //         }
              //       },
              //       child: rightThumbSlider,
              //     ),
              //     SizedBox(height: 10.h),
              //     Text(upperValue.toString())
              //   ],
              // ),

              ///unselected bar after second thumb
              Expanded(
                flex: widget.max - selectedValue,
                child: Column(
                  children: [
                    Container(
                      height: widget.barHeight * 1,
                      decoration: BoxDecoration(
                        color: widget.deselectedColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30.sp),
                          topRight: Radius.circular(30.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text('')
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(height: 10.h),

          ///abc
          /* ///Indicator section
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                // leftLabel,
              Expanded(
                flex: lowerValue - widget.min,
                child: Container(),
              ),
              // getDefaultLabel(),
              Expanded(
                flex: upperValue - lowerValue,
                child: Container(),
              ),
              // getDefaultLabel(isLeft: false),
              Expanded(
                flex: widget.max - upperValue,
                child: Container(),
              ),
              // rightLabel,
            ],
          ),
*/
        ],
      );
    });
  }
}

class RangeSliderValues {
  int lowerValue;

  // int upperValue;

  RangeSliderValues({
    required this.lowerValue,
  });
}
