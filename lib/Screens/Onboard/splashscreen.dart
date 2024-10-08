import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Server/firebase.dart';
import 'package:thopaa/Server/firebase_messaging_utils.dart';
import 'package:thopaa/export.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  bool appNotSynced = false;

  AuthService auth = AuthService();
  String? currentAddress;
  String? itemSelected;
  Position? currentPosition;
  late Placemark placeNow;

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      getAddressFromLatLng(position).then((place) {
        setState(() {
          currentAddress =
              '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
        });
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<Placemark> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        placeNow = place;
      });
    }).catchError((e) {
      debugPrint(e);
    });

    return placeNow;
  }

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness:
              appStore.isDarkMode ? Brightness.light : Brightness.dark);

      init();
    });
  }

  Future<void> init() async {
    await appStore.setLanguage(
        getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));

    ///Set app configurations
    await getAppConfigurations().then((value) {}).catchError((e) async {
      if (!await isNetworkAvailable()) {
        toast(errorInternetNotAvailable);
      }
      log(e);
    });

    auth.getCurrentUser().then((user) {
      auth.fetchUserDetails(user.uid).then((userData) {
        saveUserData(userData);
        PushNotificationService().getToken().then((fcm) {
          auth.updateUser(user.uid, fcm!, 'api_token');
        });
        auth.updateUser(user.uid, currentPosition!.latitude, 'lat');
        auth.updateUser(user.uid, currentPosition!.longitude, 'long');
      });
    });

    appStore.setLoading(false);
    if (!getBoolAsync(IS_APP_CONFIGURATION_SYNCED_AT_LEAST_ONCE)) {
      appNotSynced = true;
      setState(() {});
    } else {
      int themeModeIndex =
          getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
      if (themeModeIndex == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(
            MediaQuery.of(context).platformBrightness == Brightness.dark);
      }

      // if (appConfigurationStore.maintenanceModeStatus) {
      //   MaintenanceModeScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      // } else {
      if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
        WalkThroughScreen().launch(context,
            isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        if (getBoolAsync(IS_LOGGED_IN)) {
          HomeScreenView().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        } else {
          SignInScreenView().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        }
      }
      // }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            appStore.isDarkMode ? splash_background : splash_light_background,
            height: context.height(),
            width: context.width(),
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(appLogo, height: 120, width: 120),
              32.height,
              Text(APP_NAME,
                  style: boldTextStyle(
                      size: 26,
                      color: appStore.isDarkMode ? Colors.white : Colors.black),
                  textAlign: TextAlign.center),
              16.height,
              if (appNotSynced)
                Observer(
                  builder: (_) => appStore.isLoading
                      ? LoaderWidget().center()
                      : TextButton(
                          child: Text(language.reload, style: boldTextStyle()),
                          onPressed: () {
                            appStore.setLoading(true);
                            init();
                          },
                        ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
