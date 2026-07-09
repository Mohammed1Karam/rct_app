import 'package:app_links/app_links.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:rct/common copounents/locale_provider.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/firebase_options.dart';
import 'package:rct/model/auth/login_model.dart';
import 'package:rct/model/auth/register_model.dart';
import 'package:rct/model/build_types_model.dart';
import 'package:rct/model/complex_model.dart';
import 'package:rct/model/cooperativeMdel.dart';
import 'package:rct/model/designs_order_model.dart';
import 'package:rct/model/modelget.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/model/realEstatemodel.dart';
import 'package:rct/model/receipts_model.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/services/cache_helper.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/splash.dart';
import 'package:rct/view-model/cubits/build_types_and_floors/build_types_and_floors_cubit.dart';
import 'package:rct/view-model/cubits/complex/complex_cubit.dart';
import 'package:rct/view-model/cubits/cooperationandDevelopment/cooperative_cubit.dart';
import 'package:rct/view-model/cubits/designs/designs_cubit.dart';
import 'package:rct/view-model/cubits/favourite/favourite_cubit.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view-model/cubits/order number/order_number_cubit.dart';
import 'package:rct/view-model/cubits/order/order_cubit.dart';
import 'package:rct/view-model/cubits/orders list/orders_list_cubit.dart';
import 'package:rct/view-model/cubits/preferable/preferable_cubit.dart';
import 'package:rct/view-model/cubits/real_estate/post_cubit.dart';
import 'package:rct/view-model/cubits/real_estate/real_estate_cubit.dart';
import 'package:rct/view-model/cubits/receipts/receipts_cubit.dart';
import 'package:rct/view-model/cubits/register/register_cubit.dart';
import 'package:rct/view-model/cubits/sketches/sketches_cubit.dart';
import 'package:rct/view-model/cubits/types/types_cubit.dart';

import 'package:rct/view/RealEstate/bloc_helper.dart';
import 'package:rct/view/RealEstate/details_screen.dart';

import 'package:rct/view/notification/notification-detaails2.dart';
import 'package:rct/view/notification/notifications_screen.dart';
import 'package:rct/view/notification/notifycubit.dart';

import 'package:rct/view/final_orders/orders_screen.dart';
import 'package:rct/view/onboarding/onboarding_screen_1.dart';
import 'package:rct/view/ownership/ownership_details_screen.dart';
import 'package:rct/view/ownership/renters_cubit.dart';
import 'package:rct/view/partener_success/cubit.dart';
import 'package:rct/view/share_rct/details.dart';

import 'constants/linkapi.dart';
import 'generated/l10n.dart';
import 'view/share_rct/cubit.dart';

late FlutterSecureStorage secureStorage;
late AppLinks appLinks;
late GlobalKey<NavigatorState> navigatorKey;
void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  appLinks = AppLinks();
  navigatorKey = GlobalKey<NavigatorState>();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  secureStorage = const FlutterSecureStorage();

  // await UniLinkHelper.instance.handleInitialUri();
  // UniLinkHelper.instance.initDeepLinkListener();

  appLinks.getInitialLink().then((initialLink){
    if(initialLink!=null && initialLink.pathSegments.isNotEmpty){
      if (initialLink.pathSegments.contains("product")) {
        _handleProductDetailsLink(initialLink);
      }else if(initialLink.pathSegments.contains("details")){
        _handleRentDetailsLink(initialLink);
      }else if(initialLink.pathSegments.contains("share")){
        _handleShareDetailsLink(initialLink);
      }
    }
  });

  appLinks.uriLinkStream.listen((initialLink){
    if(initialLink!=null && initialLink.pathSegments.isNotEmpty){
      if (initialLink.pathSegments.contains("product")) {
        _handleProductDetailsLink(initialLink);
      }
    }
  });
  Bloc.observer = MyBlocObserver();
  AppPreferences.init();
  await Firebase.initializeApp();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  print(CacheHelper.getData(key: "lang"));
  if (CacheHelper.getData(key: "lang") == null) {
    CacheHelper.saveData(key: "lang", value: "ar");
  }

  secureStorage = const FlutterSecureStorage();
  AwesomeNotifications().initialize(
    "resource://drawable/test",
    [
      NotificationChannel(
        channelKey: 'local notification key',
        channelName: 'local notification channel name',
        channelDescription: 'local notification channel description',
        playSound: true,
        vibrationPattern: highVibrationPattern,
        importance: NotificationImportance.Max,
        onlyAlertOnce: true,
        defaultPrivacy: NotificationPrivacy.Private,
        channelShowBadge: true,
        // Optional: add custom sound if neededflutter build appbundle --release

        // soundSource: 'resource://raw/sound',
      ),
      NotificationChannel(
        channelKey: 'local notification key back',
        channelName: 'local notification channel name back',
        channelDescription: 'local notification channel description back',
        playSound: true,
        vibrationPattern: highVibrationPattern,
        importance: NotificationImportance.Max,
        onlyAlertOnce: true,
        defaultPrivacy: NotificationPrivacy.Private,
        channelShowBadge: true,
        // Optional: add custom sound if needed
        // soundSource: 'resource://raw/sound',
      ),
    ],
    debug: true,
  );

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await firebaseMessaging.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_handlePushNotifications);
  firebaseMessaging.setForegroundNotificationPresentationOptions(
    sound: true,
    alert: true,
    badge: true,
  );

  AppPreferences.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginModel>(
          create: (_) => LoginModel(),
        ),
        ChangeNotifierProvider<RegisterModel>(
          create: (_) => RegisterModel(),
        ),
        ChangeNotifierProvider<OrderModel>(
          create: (_) => OrderModel(),
        ),
        ChangeNotifierProvider<HouseModel>(
          create: (_) => HouseModel(),
        ),
        ChangeNotifierProvider<BuildTypesModel>(
          create: (_) => BuildTypesModel(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider<DesignsOrderModel>(
          create: (_) => DesignsOrderModel(),
        ),
        ChangeNotifierProvider<ComplexModel>(
          create: (_) => ComplexModel(),
        ),
        ChangeNotifierProvider<ReceiptsModel>(
          create: (_) => ReceiptsModel(),
        ),
        ChangeNotifierProvider<OrderModel>(
          create: (_) => OrderModel(),
        ),
        ChangeNotifierProvider<CooperativeModel>(
          create: (_) => CooperativeModel(),
        ),
        ChangeNotifierProvider<NotificationDetails222>(
          create: (_) => NotificationDetails222(),
        ),
        ChangeNotifierProvider<Modelget>(
          create: (_) => Modelget(),
        ),
        ChangeNotifierProvider<RenterModel>(
          create: (_) => RenterModel(),
        ),
      ],
      child: const ScreenUtilInit(
        designSize: Size(393, 852),
        child: MyApp(),
      ),
    ),
  );
}

void _handleShareDetailsLink(Uri initialLink) {
  final String? propertyId = initialLink.pathSegments.last;
  if (propertyId != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
              builder: (context) => ShareDetails(id: propertyId)
          ),
        );
      } else {
        Future.delayed(const Duration(milliseconds: 500), () => _handleProductDetailsLink(initialLink));
      }
    });
  }
}

void _handleRentDetailsLink(Uri initialLink) {
  final String? propertyId = initialLink.pathSegments.last;
  if (propertyId != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
              builder: (context) => OwnershipDetailsScreen(id: propertyId)
          ),
        );
      } else {
        Future.delayed(const Duration(milliseconds: 500), () => _handleProductDetailsLink(initialLink));
      }
    });
  }
}

void _handleProductDetailsLink(Uri initialLink) {
  final String? productId = initialLink.pathSegments.last;
  if (productId != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              id: productId,
              isdeeplink: true,
            ),
          ),
        );
      } else {
        Future.delayed(const Duration(milliseconds: 500), () => _handleProductDetailsLink(initialLink));
      }
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          //NotificationCubit
          BlocProvider(
            create: (context) => NotificationCubit(),
          ),
          // BlocProvider(
          //   create: (context) => LoginCubit(),
          // ),
          BlocProvider(
            create: (context) => RegisterCubit(),
          ),
          BlocProvider(
            create: (context) => SketchesCubit(),
          ),
          BlocProvider(
            create: (context) => FinalOrdersCubit(),
          ),
          BlocProvider(
            create: (context) => DesignsCubit(),
          ),
          BlocProvider(
            create: (context) => TypesCubit(),
          ),
          BlocProvider(
            create: (context) => OrderNumberCubit(),
          ),
          BlocProvider(
            create: (context) => BuildTypesAndFloorsCubit(),
          ),

          BlocProvider(
            create: (context) => ShareCubit(),
          ),

          BlocProvider(
            create: (context) => FavouriteCubit(),
          ),
          BlocProvider(
            create: (context) => OrderCubit(),
          ),
          BlocProvider(
            create: (context) => HouseCubit(),
          ),
          BlocProvider(
            create: (context) => PreferableCubit(),
          ),

          BlocProvider(
            create: (context) => ComplexCubit(),
          ),
          BlocProvider(
            create: (context) => ReceiptsCubit(),
          ),
          BlocProvider(
            create: (context) => CooperativeCubit(),
          ),
          BlocProvider(
            create: (context) => OrdersListCubit()..fetchOrderList(),
            child: const OrderListScreen(),
          ),
          BlocProvider<DataCubit>(
            create: (context) => DataCubit(),
          ),
          BlocProvider<ParetenerCubit>(
            create: (context) => ParetenerCubit(),
          ),
          BlocProvider<NotificationCubit>(
            create: (context) => NotificationCubit(),
          ),
          BlocProvider<RentersCubit>(
            create: (context) => RentersCubit(),
          ),
        ],
        child: Consumer<LocaleProvider>(
          builder: (context, provider, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.15), // Locks text scaling
            ),
            child: MaterialApp(
              title: 'RCT App',
              navigatorKey: navigatorKey,
              theme: ThemeData(
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
                checkboxTheme: const CheckboxThemeData(
                  checkColor: WidgetStatePropertyAll(Colors.white),
                ),
                fontFamily: p.join('URW-DIN-Arabic'),
                primaryColor: primaryColor,
                tabBarTheme: TabBarThemeData(
                  indicatorColor: primaryColor,
                  unselectedLabelStyle: const TextStyle(),
                  labelStyle: const TextStyle(),
                ),
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: SplashScreen.id,
              // localizationsDelegates: AppLocalizations.localizationsDelegates,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              // supportedLocales: AppLocalizations.supportedLocales,
              locale: provider.locale,
              localeResolutionCallback: (locale, supportedLocales) {
                // Check if the device locale is supported
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                // If not, fallback to the first supported locale
                return supportedLocales.first;
              },
              // home: CacheHelper.getData(key: "hasCompletedOnboarding")??false?HomeScreen():OnboardingScreen(),
              home: SplashScreen(),
            ),
          ),
        ));
  }
}

Future<void> _handlePushNotifications(RemoteMessage message) async {}
