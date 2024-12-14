import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_providers/shared_pref_helper.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/firebase_messaging/constants/constants.dart';
import 'package:opclo/models/favorite_model.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../firebase_messaging/firebase_messaging_class.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../home/controller/sheet_height_controller.dart';
import '../../subscription/data/apis/iap_service.dart';
import '../controller/main_menu_controller.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  StreamSubscription<List<PurchaseDetails>>? _iapSubscription;
  bool _isSubscribed = false;


  @override
  initState() {
    super.initState();
    initialization();
    initializationMF();
  }

  void inAppPurchasesListener({required UserModel userModel}) {
    if (!_isSubscribed) {
      final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
      _iapSubscription = purchaseUpdated.listen((purchaseDetailsList) {
        print("Purchase stream started");
        IAPService(userModel.uid,userModel,ref).listenToPurchaseUpdated(purchaseDetailsList,context,ref);
      }, onDone: () {
        _iapSubscription?.cancel();
      }, onError: (error) {
        _iapSubscription?.cancel();
      }) as StreamSubscription<List<PurchaseDetails>>;
      _isSubscribed = true;
    }
  }

  /// Here in this method, we are initializing necessary methods
  initialization() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserModel? userModel =
          await ref.read(authControllerProvider.notifier).getCurrentUserInfo();
      if (userModel != null){
        await ref.read(authControllerProvider.notifier).fcmTokenUpload(userModel: userModel);
        inAppPurchasesListener(userModel: userModel);
      }
      ref.read(authNotifierCtr).setUserModelData(userModel);
      SharedPrefHelper.storeInstallationTime();
      ref.read(mainMenuProvider).showReviewPopupIfNeeded(context);
    });
  }

  initializationMF() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    });
    try{
      await MessagingFirebase().subscribeTo(topicName: Constants.allUsers);
    }catch(e){
      debugPrint("Exception In MF: "+ e.toString());
    }
  }

  @override
  void dispose() {
    _iapSubscription?.cancel();
    // _iapSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainMenuCtr = ref.watch(mainMenuProvider);
    return Scaffold(
      backgroundColor: context.whiteColor,
      body: IndexedStack(
        children: [mainMenuCtr.screens[mainMenuCtr.index]],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 10.r,
          type: BottomNavigationBarType.fixed,
          backgroundColor: context.whiteColor,
          onTap: (value) {
            if (value == 0) {
              ref.read(sheetHeightProvider).setHeight(40.h);
            }
            try{
              mainMenuCtr.setIndex(value);
            }catch(e){
              print(e.toString());
            }
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: mainMenuCtr.index,
          selectedFontSize: MyFonts.size8,
          unselectedFontSize: MyFonts.size8,
          selectedIconTheme: IconThemeData(size: 23.r),
          unselectedLabelStyle: getSemiBoldStyle(
              color: context.titleColor.withOpacity(0.3),
              fontSize: MyFonts.size8),
          selectedLabelStyle: getSemiBoldStyle(
              color: context.primaryColor, fontSize: MyFonts.size8),
          enableFeedback: false,
          selectedItemColor: context.primaryColor,
          unselectedItemColor: context.titleColor.withOpacity(0.3),
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: SvgPicture.asset(
                    AppAssets.home,
                    width: 18.w,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                        mainMenuCtr.index == 0
                            ? context.primaryColor
                            : context.titleColor.withOpacity(.2),
                        BlendMode.srcIn),
                  ),
                ),
                label: 'HOME',
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: SvgPicture.asset(
                    AppAssets.heartSvg,
                    width: 18.w,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                        mainMenuCtr.index == 1
                            ? context.primaryColor
                            : context.titleColor.withOpacity(.3),
                        BlendMode.srcIn),
                  ),
                ),
                label: 'LISTS',
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child:
                      SvgPicture.asset(
                    AppAssets.savings,
                        width: 18.w,
                        height: 18.h,
                    colorFilter: ColorFilter.mode(
                        mainMenuCtr.index == 2
                            ? context.primaryColor
                            : context.titleColor.withOpacity(.3),
                        BlendMode.srcIn),
                  ),
                  // ),
                ),
                label: 'SAVINGS'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: SvgPicture.asset(
                    AppAssets.friends,
                    width: 18.w,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                        mainMenuCtr.index == 3
                            ? context.primaryColor
                            : context.titleColor.withOpacity(.3),
                        BlendMode.srcIn),
                  ),
                ),
                label: 'FRIENDS'
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: SvgPicture.asset(
                    AppAssets.profile,
                    width: 18.w,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                        mainMenuCtr.index == 4
                            ? context.primaryColor
                            : context.titleColor.withOpacity(.3),
                        BlendMode.srcIn),
                  ),
                ),
                label: 'PROFILE'
            ),
          ],
        ),
      ),
    );
  }
}
