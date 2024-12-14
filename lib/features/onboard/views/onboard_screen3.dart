import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/check_conectivity.dart';
import 'package:opclo/commons/common_providers/shared_pref_helper.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/onboard/controller/prefrences_controller.dart';
import 'package:opclo/features/user/main_menu/controller/conectivity_notifier.dart';
import 'package:opclo/models/preference_model/preference_model.dart';
import 'package:uuid/uuid.dart';
import '../../../commons/common_enum/goal_enum/goal_enum.dart';
import '../../../commons/common_functions/padding.dart';
import '../../../commons/common_imports/common_libs.dart';
import '../../../commons/common_widgets/custom_button.dart';
import '../../../routes/route_manager.dart';
import '../../../utils/constants/font_manager.dart';

class OnboardScreen3 extends StatefulWidget {
  const OnboardScreen3({Key? key}) : super(key: key);

  @override
  State<OnboardScreen3> createState() => _OnboardScreen3State();
}

class _OnboardScreen3State extends State<OnboardScreen3> {
  List<GoalEnum> selectedBubbles = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
                  child: Text(
                    'step 3 of 3',
                    style: getBoldStyle(
                        color: context.titleColor.withOpacity(.3),
                        fontSize: MyFonts.size12),
                  ),
                ),
              ),
              padding12,
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0.h),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'What do you want to achieve?',
                        textAlign: TextAlign.center,
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size23),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 450.h,
              ),
              Positioned(
                  top: 0.h,
                  left: 0.27.sw,
                  child: BubbleWidget(
                    title: GoalEnum.achieveTravelGoals,
                    //'Achieve Travel Goals',
                    size: 133.h,
                    onTap: (GoalEnum title) {
                      handleBubbleSelection(title);
                    },
                  )),
              Positioned(
                  top: 80.h,
                  right: 10.w,
                  child: BubbleWidget(
                    title: GoalEnum.discoverNewPlaces, //'Discover New Places',
                    size: 106.h,
                    onTap: (GoalEnum title) {
                      handleBubbleSelection(title);
                    },
                  )),
              Positioned(
                  top: 100.h,
                  left: 10.w,
                  child: BubbleWidget(
                    title: GoalEnum.receiveGreatDeals, //'Receive Great Deals',
                    size: 106.h,
                    onTap: (GoalEnum title) {
                      handleBubbleSelection(title);
                    },
                  )),
              Positioned(
                  top: 150.h,
                  left: 0.30.sw,
                  child: BubbleWidget(
                    title: GoalEnum.stayInformedWithPlaceAlerts,
                    //'Stay Informed with Place Alerts',
                    size: 133.h,
                    onTap: (GoalEnum title) {
                      handleBubbleSelection(title);
                    },
                  )),
              Positioned(
                  top: 230.h,
                  left: 0.w,
                  child: BubbleWidget(
                    title: GoalEnum.buildBucketLists, //'Build Bucket Lists',
                    size: 119.h,
                    onTap: (GoalEnum title) {
                      handleBubbleSelection(title);
                    },
                  )),
              Positioned(
                  top: 230.h,
                  right: 0.w,
                  child: BubbleWidget(
                    title: GoalEnum.planSpecialOccasions,
                    //'Plan Special Occasions',
                    size: 119.h,
                    onTap: (GoalEnum title) {
                      handleBubbleSelection(title);
                    },
                  )),
              Positioned(
                  top: 300.h,
                  left: 0.35.sw,
                  child: BubbleWidget(
                    title: GoalEnum.organizeDailyLife, //'Organize Daily Life',
                    size: 119.h,
                    onTap: (GoalEnum title) {
                      handleBubbleSelection(title);
                    },
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Consumer(builder: (context, ref, child) {
              return CustomButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await SharedPrefHelper.savePreference('Saved');
                    final show = await SharedPrefHelper.getShowCase();
                    final isInternet = await isInternetConnected();
                    setState(() {
                      isLoading = false;
                    });
                    if (selectedBubbles.isNotEmpty) {
                      final pref = PreferenceModel(
                          id: Uuid().v4(),
                          goals: selectedBubbles,
                          date: DateTime.now());
                      ref
                          .read(preferencesControllerProvider.notifier)
                          .savePreference(pref: pref);
                    }
                    Navigator.pushNamed(
                      context,
                      show && isInternet
                          ? AppRoutes.registrationScreen
                          : AppRoutes.mainMenuScreen,
                    );
                  },
                  isLoading: isLoading,
                  buttonText: 'Continue');
            }),
          ),
          padding8,
        ],
      ),
    );
  }

  // Method to handle bubble selection/deselection
  void handleBubbleSelection(GoalEnum title) {
    setState(() {
      if (selectedBubbles.contains(title)) {
        selectedBubbles.remove(title);
      } else {
        selectedBubbles.add(title);
      }
    });
  }
}

class BubbleWidget extends StatefulWidget {
  final GoalEnum title;
  final double size;
  final Function(GoalEnum) onTap;

  BubbleWidget({required this.title, required this.size, required this.onTap});

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onTap(widget.title);
      },
      child: AnimatedSize(
        clipBehavior: Clip.none,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInCirc,
        child: Container(
          width: widget.size,
          height: widget.size,
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          padding: EdgeInsets.all(
            12.r,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? context.primaryColor : context.whiteColor,
              boxShadow: [
                isSelected
                    ? BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 2,
                        color: context.primaryColor.withOpacity(1),
                        offset: const Offset(0, 3),
                      )
                    : BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 2,
                        color: context.primaryColor.withOpacity(.08),
                        offset: const Offset(0, 3),
                      )
              ]),
          child: Center(
            child: Text(
              toGoalEnum(widget.title),
              textAlign: TextAlign.center,
              style: getMediumStyle(
                  color: isSelected ? context.whiteColor : context.primaryColor,
                  fontSize: MyFonts.size12),
            ),
          ),
        ),
      ),
    );
  }
}
