import 'package:flutter/material.dart';
import 'package:opclo/features/auth/view/signin_screen.dart';
import 'package:opclo/features/auth/view/staff_portal_sigin.dart';
import 'package:opclo/features/onboard/views/onborad_screen1.dart';
import 'package:opclo/features/splash/views/splash.dart';
import 'package:opclo/features/user/alert/alerts_extended/blac_or_women_owned/black_or_women_owned.dart';
import 'package:opclo/features/user/alert/alerts_extended/close/views/temporarily_close.dart';
import 'package:opclo/features/user/alert/alerts_extended/covid/views/covid_screen.dart';
import 'package:opclo/features/user/alert/alerts_extended/hours/views/hours_screen.dart';
import 'package:opclo/features/user/alert/alerts_extended/moved_location/views/moved_location.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/views/occasions_screen.dart';
import 'package:opclo/features/user/alert/alerts_extended/recommendation/views/recommendation_screen.dart';
import 'package:opclo/features/user/articles/views/articles.dart';
import 'package:opclo/features/user/coupons/views/coupons_screen.dart';
import 'package:opclo/features/user/coupons/views/coupos_detail_screen.dart';
import 'package:opclo/features/user/coupons/views/list_of_coupons.dart';
import 'package:opclo/features/user/favorites/views/favourite_list_screen.dart';
import 'package:opclo/features/user/feedback/views/feedback_screen.dart';
import 'package:opclo/features/user/home/views/home_and_work_screen.dart';
import 'package:opclo/features/user/home/views/places_list_screen.dart';
import 'package:opclo/features/user/home/views/top_places_screen.dart';
import 'package:opclo/features/user/no_internet/views/no_connection.dart';
import 'package:opclo/features/user/profile/profile_extended/add_note/views/add_note_screen.dart';
import 'package:opclo/features/user/profile/profile_extended/edit_profile/views/edit_profile.dart';
import 'package:opclo/features/user/profile/profile_extended/profile_detail/profile_detail_extended/change_password/views/change_password.dart';
import 'package:opclo/features/user/profile/profile_extended/profile_detail/views/profile_detail_screen.dart';
import 'package:opclo/features/user/reminder/views/accept_reminder_invitation.dart';
import 'package:opclo/features/user/reminder/views/reminders_screen.dart';
import 'package:opclo/features/user/reminder/views/set_reminder_screen.dart';
import 'package:opclo/features/user/restaurant/views/detail_view_screen.dart';
import 'package:opclo/features/user/restaurant/views/place_detail_usingId_screen.dart';
import 'package:opclo/features/user/restaurant/views/places_query_screen.dart';
import 'package:opclo/features/user/restaurant/views/places_screen.dart';
import 'package:opclo/features/user/search/search_extended/catergories/views/more_categories.dart';
import 'package:opclo/features/user/search/views/map_screen.dart';
import 'package:opclo/features/user/search/views/map_view.dart';
import 'package:opclo/features/user/search/views/no_place_open.dart';
import 'package:opclo/features/user/search/views/places_chain_screen.dart';
import 'package:opclo/features/user/search/views/search_result_screen.dart';
import 'package:opclo/features/user/search/views/search_screen.dart';
import 'package:opclo/features/user/share/views/share_screen.dart';
import 'package:opclo/features/user/subscription/views/conformation_screen.dart';
import 'package:opclo/features/user/subscription/views/store_view.dart';
import 'package:opclo/features/user/subscription/views/subscription_screen.dart';
import 'package:opclo/features/user/welcome/views/follow_favorites_screen.dart';
import 'package:opclo/main.dart';
import 'package:opclo/utils/error_screen.dart';
import '../features/auth/view/registration_screen.dart';
import '../features/onboard/views/onboard_screen3.dart';
import '../features/onboard/views/onborad_screen2.dart';
import '../features/user/alert/alerts_extended/dineInOrDineThru/views/dinein_or_dinethru.dart';
import '../features/user/alert/views/alerts.dart';
import '../features/user/favorites/views/favorites_screen.dart';
import '../features/user/location/views/no_location.dart';
import '../features/user/main_menu/views/main_menu_screen.dart';
import '../features/user/notification/views/notification_screen.dart';
import 'navigation.dart';

class AppRoutes {
  static const String myApp = '/myApp';
  static const String signInScreen = '/signInScreen';
  static const String staffPortalSignInScreen = '/staffPortalSignInScreen';
  static const String splashScreen = '/splashScreen';
  static const String onboardScreen1 = '/onboardScreen1';
  static const String onboardScreen2 = '/onboardScreen2';
  static const String onboardScreen3 = '/onboardScreen3';
  static const String homeAndWorkScreen = '/homeAndWorkScreen';
  static const String followFavoriteScreen = '/followFavoriteScreen';
  static const String subscriptionScreen = '/subscriptionScreen';
  static const String subscriptionScreenFromSignup =
      '/subscriptionScreenFromSignup';
  static const String conformationScreen = '/conformationScreen';
  static const String addNoteScreen = '/addNoteScreen';
  static const String placesScreen = '/placesScreen';
  static const String searchScreen = '/searchScreen';
  static const String alerts = '/alerts';
  static const String movedLocation = '/movedLocation';
  static const String temporarilyClose = '/temporarilyClose';
  static const String dineInOrDineThru = '/dineInOrDineThru';
  static const String blackOrWomenOwned = '/blackOrWomenOwned';
  static const String hoursScreen = '/hoursScreen';
  static const String occasionsScreen = '/occasionsScreen';
  static const String covidScreen = '/covidScreen';
  static const String recommendationScreen = '/recommendationScreen';
  static const String shareScreen = '/shareScreen';
  static const String noPlaceOpen = '/noPlaceOpen';
  static const String mapScreen = '/mapScreen';
  static const String noLocationScreen = '/noLocationScreen';
  static const String articles = '/articles';
  static const String detailResturantScreen = '/DetailViewScreen';
  static const String placeDetailUsingIdScreen = '/placeDetailUsingIdScreen';
  static const String alertScreen = '/alertScreen';
  static const String favouritesScreen = '/favouritesScreen';
  static const String noConnectionScreen = '/noConnectionScreen';
  static const String profileDetailScreen = '/profileDetailScreen';
  static const String couponsDetailScreen = '/couponsDetailScreen';
  static const String couponsScreen = '/couponsScreen';
  static const String reminderScreen = '/reminderScreen';
  static const String acceptReminderScreen = '/acceptReminderScreen';
  static const String setReminderScreen = '/setReminderScreen';
  static const String moreCategoriesScreen = '/moreCategoriesScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String feedbackScreen = '/feedbackScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String placeslistScreen = '/placeslistScreen';
  static const String placesQueryScreen = '/placesQueryScreen';
  static const String placeChainScreen = '/placesChainScreen';
  static const String topPlacesListScreen = '/topPlacesListScreen';
  static const String favouriteListScreen = '/favouriteListScreen';
  static const String mapView = '/mapView';
  static const String listOfCouponsScreen = '/listOfCouponsScreen';
  static const String mainMenuScreen = '/mainMenuScreen';
  static const String searchResultScreen = '/searchResultScreen';
  static const String storeView = "/storeView";
  static const String registrationScreen = "/registrationScreen";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return _buildRoute(const SplashScreen());
      case myApp:
        return _buildRoute(const MyApp());
      case onboardScreen1:
        return _buildRoute(OnboardScreen1());
      case onboardScreen2:
        return _buildRoute(const OnboardScreen2());
      case onboardScreen3:
        return _buildRoute(const OnboardScreen3());
      case mainMenuScreen:
        return _buildRoute(const MainMenuScreen());
      case signInScreen:
        return _buildRoute(SignInScreen());
      case homeAndWorkScreen:
        return _buildRoute(HomeAndWorkScreen());
      case followFavoriteScreen:
        return _buildRoute(FollowFavoritesScreen());
      case subscriptionScreen:
        return _buildRoute(SubSubscriptionScreen(
          fromSignup: false,
        ));
      case subscriptionScreenFromSignup:
        return _buildRoute(SubSubscriptionScreen(
          fromSignup: true,
        ));
      case conformationScreen:
        return _buildRoute(ConformationScreen());
      case addNoteScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(AddNoteScreen(
          noteModel: arguments?['noteModel'],
          place: arguments?['place'],
        ));
      case placesScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(PlacesScreen(
          categoryIds: arguments?['categoryIds'],
          categoryName: arguments?['categoryName'],
          query: arguments?['query'],
          radius: arguments?['radius'],
          isTopPlace: arguments?['isTopPlace'],
        ));
      case searchScreen:
        return _buildRoute(SearchScreen());
      case alerts:
        return _buildRoute(Alerts());
      case covidScreen:
        return _buildRoute(const CovidScreen());
      case occasionsScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(OccasionsScreen(
          fsqId: arguments?['fsqId'],
        ));
      case movedLocation:
        return _buildRoute(const MovedLocation());
      case temporarilyClose:
        return _buildRoute(const TemporarilyColse());
      case dineInOrDineThru:
        return _buildRoute(const DineInOrDineThru());
      case blackOrWomenOwned:
        return _buildRoute(const BlackOrWomenOwned());
      case recommendationScreen:
        return _buildRoute(const RecommendationScreen());
      case hoursScreen:
        return _buildRoute(const HoursScreen());
      case shareScreen:
        return _buildRoute(const ShareScreen());
      case noPlaceOpen:
        return _buildRoute(const NoPlaceOpen());
      case detailResturantScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(DetailViewScreen(
          placeModel: arguments?['placeModel'],
        ));
      case placeDetailUsingIdScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(PlaceDetailUsingIdScreen(
          placeId: arguments?['placeId'],
        ));
      case acceptReminderScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(AcceptReminderInvitation(
          reminderModel: arguments?['reminderModel'],
        ));
      case articles:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(Articles(
          model: arguments?['model'],
        ));
      case mapScreen:
        return _buildRoute(MapScreen());
      case storeView:
        return _buildRoute(StoreView());
      // case noLocationScreen:
      //   return _buildRoute(NoLocation());
      case alertScreen:
        return _buildRoute(Alerts());
      case favouritesScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(FavouritesScreen(pop: arguments?['pop'],));
      case noConnectionScreen:
        return _buildRoute(NoConnection(
          onTap: () {},
        ));
      case profileDetailScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(ProfileDetailScreen(
            //    userModel: arguments?['userModel'],
            ));
      case couponsScreen:
        return _buildRoute(CouponsScreen());
      case listOfCouponsScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(ListOfCoupons(
          category: arguments?['category'],
        ));
      case couponsDetailScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(CouponsDetailScreen(
          couponModel: arguments?['couponModel'],
        ));
      case reminderScreen:
        return _buildRoute(RemindersScreen());
      case setReminderScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(SetReminderScreen(
          placeModel: arguments?['placeModel'],
        ));
      case moreCategoriesScreen:
        return _buildRoute(MoreCategories());
      case editProfileScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(EditProfile(
          userModel: arguments?['userModel'],
        ));
      case changePasswordScreen:
        return _buildRoute(ChangePasswordScreen());
      case staffPortalSignInScreen:
        return _buildRoute(const StaffPortalSignInScreen());
      case feedbackScreen:
        return _buildRoute(const FeedBackScreen());
      case notificationScreen:
        return _buildRoute(const NotificationScreen());
      case placeslistScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(PlacesListScreen(
          categoryName: arguments?['categoryName'],
          categoriesId: arguments?['categoriesId'],
        ));
      case placesQueryScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(PlacesQueryScreen(
          categoryName: arguments?['categoryName'],
          query: arguments?['query'],
        ));
      case placeChainScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(PlacesChainScreen(
          categoryName: arguments?['categoryName'],
          chainId: arguments?['chainId'],
        ));
      case topPlacesListScreen:
        return _buildRoute(TopPlacesScreen());
      case favouriteListScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(FavouriteListScreen(
          groupId: arguments?['groupId'],
        ));
      case mapView:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
            MapView(lat: arguments?['lat'], lng: arguments?['lng']));
      case searchResultScreen:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(SearchResultScreen(query: arguments?['query']));
        case registrationScreen:
        return _buildRoute(RegistrationScreen());

      default:
        return unDefinedRoute();
    }
  }

  static unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(
              backgroundColor: Colors.white,
            ));
    return MaterialPageRoute(builder: (_) => const ErrorScreen());
  }

  static _buildRoute(Widget widget, {int? duration = 400}) {
    return forwardRoute(widget, duration);
  }

  static _buildNormalRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }
}
