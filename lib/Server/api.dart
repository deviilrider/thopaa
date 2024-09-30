//region Configurations Api
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Model/user_data_model.dart';
import 'package:thopaa/export.dart';

Future<void> getAppConfigurations(
    {bool isCurrentLocation = false, double? lat, double? long}) async {
  DateTime currentTimeStamp = DateTime.timestamp();
  DateTime lastSyncedTimeStamp = DateTime.fromMillisecondsSinceEpoch(
      getIntAsync(LAST_APP_CONFIGURATION_SYNCED_TIME));
  lastSyncedTimeStamp = lastSyncedTimeStamp.add(Duration(minutes: 5));

  if (lastSyncedTimeStamp.isAfter(currentTimeStamp)) {
    log('App Configurations was synced recently');
  } else {
    try {
      // AppConfigurationModel? res = AppConfigurationModel.fromJsonMap(await handleResponse(await buildHttpResponse('configurations?is_authenticated=${appStore.isLoggedIn.getIntBool()}', method: HttpMethodType.POST)));

      AppConfigurationModel res = AppConfigurationModel.fromJsonMap({});
      await setAppConfigurations(res);
    } catch (e) {
      throw e;
    }
  }
}
//endregion

//get location
Future<bool> handleLocationPermission(context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}

Future<void> saveUserData(UserData data,
    {bool forceSyncAppConfigurations = true}) async {
  if (data.apiToken.validate().isNotEmpty)
    await appStore.setToken(data.apiToken!);
  appStore.setLoggedIn(true);

  await appStore.setUserId(data.id.validate());
  await appStore.setUId(data.uid.validate());
  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.countryId.validate());
  await appStore.setStateId(data.stateId.validate());
  await appStore.setCityId(data.cityId.validate());
  await appStore.setContactNumber(data.contactNumber.validate());
  await appStore.setLoginType(data.loginType.validate(value: LOGIN_TYPE_USER));
  await appStore.setAddress(data.address.validate());

  await appStore.setUserProfile(data.profileImage.validate());

  /// Subscribe Firebase Topic
  // subscribeToFirebaseTopic();

  // Sync new configurations for secret keys
  if (forceSyncAppConfigurations)
    await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
  getAppConfigurations();
}

Future<void> clearPreferences() async {
  // cachedDashboardResponse = null;
  // cachedBookingList = null;
  // cachedCategoryList = null;
  // cachedBookingStatusDropdown = null;

  if (!getBoolAsync(IS_REMEMBERED)) {
    await appStore.setUserEmail('');
    await removeKey(IS_EMAIL_VERIFIED);
  }
  setValue(CURRENT_ADDRESS, '');
  await appStore.setCurrentLocation(false);

  /// Firebase Notification
  // unsubscribeFirebaseTopic(appStore.userId);
  await removeKey(LOGIN_TYPE);

  await appStore.setLoggedIn(false);
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setUserProfile('');
  await appStore.setAddress('');
  await appStore.setCityId(0);
  await appStore.setUId('');
  await appStore.setLatitude(0.0);
  await appStore.setLongitude(0.0);
  await appStore.setToken('');
  await appStore.setLoginType('');
  await setValue(USER_PASSWORD, '');
  await removeKey(IS_SUBSCRIBED_FOR_PUSH_NOTIFICATION);

  try {
    FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e);
  }

  appStore.setUserWalletAmount();
}

Future<void> getDataAndSave(UserData data,
    {bool forceSyncAppConfigurations = true}) async {
  if (data.apiToken.validate().isNotEmpty)
    await appStore.setToken(data.apiToken!);
  appStore.setLoggedIn(true);

  await appStore.setUserId(data.id.validate());
  await appStore.setUId(data.uid.validate());
  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.countryId.validate());
  await appStore.setStateId(data.stateId.validate());
  await appStore.setCityId(data.cityId.validate());
  await appStore.setContactNumber(data.contactNumber.validate());
  await appStore.setLoginType(data.loginType.validate(value: LOGIN_TYPE_USER));
  await appStore.setAddress(data.address.validate());

  await appStore.setUserProfile(data.profileImage.validate());

  /// Subscribe Firebase Topic
  // subscribeToFirebaseTopic();

  // Sync new configurations for secret keys
  if (forceSyncAppConfigurations)
    await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
  getAppConfigurations();
}

Future<void> logout(BuildContext context) async {
  return showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (p0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(logout_image, width: context.width(), fit: BoxFit.cover),
          32.height,
          Text(language.lblLogoutTitle, style: boldTextStyle(size: 18)),
          16.height,
          Text(language.lblLogoutSubTitle, style: secondaryTextStyle()),
          28.height,
          Row(
            children: [
              AppButton(
                child: Text(language.lblNo, style: boldTextStyle()),
                elevation: 0,
                onTap: () {
                  finish(context);
                },
              ).expand(),
              16.width,
              AppButton(
                child:
                    Text(language.lblYes, style: boldTextStyle(color: white)),
                color: primaryColor,
                elevation: 0,
                onTap: () async {
                  finish(context);

                  if (await isNetworkAvailable()) {
                    appStore.setLoading(true);

                    logout(context).then((value) async {
                      //
                    }).catchError((e) {
                      log(e.toString());
                    });

                    await clearPreferences();

                    appStore.setLoading(false);
                    HomeScreenView().launch(context,
                        isNewTask: true,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  } else {
                    toast(errorInternetNotAvailable);
                  }
                },
              ).expand(),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24);
    },
  );
}
