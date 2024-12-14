import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/features/user/reminder/api/dynamic_link_service.dart';
import 'package:opclo/features/user/reminder/controller/notification_service.dart' as alertNotification;
import 'package:opclo/routes/route_manager.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/thems/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'features/user/profile/profile_extended/add_note/controller/note_controller.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_messaging/service/notification_service.dart';
import 'models/note_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // For Android
      statusBarBrightness: Brightness.light,
    ),
  );
  //alertNotification.LocalNotificationService.initialize();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (!isFirstTime) {
    LocalNotificationService.initializeNew();
  }

  tz.initializeTimeZones();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool isNotification = false;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    DynamicLinkService.initDynamicLink(context, ref);
    initiateFirebaseMessaging();
  }

  initiateFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((message) {
      isNotification = true;
      LocalNotificationService.display(
          message: message,
          context: context,
          ref: ref,
          navigatorKey: navigatorKey);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      isNotification = true;
      LocalNotificationService.displayBackgroundNotifications(
          message: message,
          context: context,
          // ref: ref,
          navigatorKey: navigatorKey);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        isNotification = true;
        LocalNotificationService.displayBackgroundNotifications(
            message: message,
            context: context,
            // ref: ref,
            navigatorKey: navigatorKey);
      }
    });
    // messagingFirebase.uploadFcmToken();
  }


  void startProximityTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position currentPosition) async {
      final notes = await ref
          .read(noteControllerProvider.notifier)
          .getAllNotes(context)
          .first;
      for (NoteModel note in notes) {
        if (note.lat != null && note.long != null) {
          double distance = Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            note.lat ?? 0,
            note.long ?? 0,
          );
          if (distance <= 1559) {
            await LocalNotificationService().showNoteNotification(
              title: "You're near a saved Note!",
              body: "You are within 100 meters of ${note.locationName ??
                  'a saved Note'}",
            );
            ref.read(noteControllerProvider.notifier).updateNotes(
                context, note.copyWith(rememberMe: false));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:
      const Size(AppConstants.screenWidget, AppConstants.screenHeight),
      splitScreenMode: true,
      builder: (context, child) {
        return ShowCaseWidget(
          builder: (context) => MaterialApp(
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            navigatorKey: navigatorKey,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(
                  textScaleFactor:
                  Theme.of(context).platform == TargetPlatform.iOS ? 1 : 1,
                ),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'Opclo',
            theme: lightThemeData(context),
            themeMode: ThemeMode.light,
            darkTheme: darkThemeData(context),
            onGenerateRoute: AppRoutes.onGenerateRoute,
            // initialRoute: AppRoutes.onboardScreen3
            initialRoute: isNotification
                ? AppRoutes.mainMenuScreen
                : AppRoutes.splashScreen,
          ),
        );
      },
    );
  }
}
