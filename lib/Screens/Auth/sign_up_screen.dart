import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Server/firebase.dart';
import 'package:thopaa/Server/handler/auth_result_handler.dart';
import 'package:thopaa/Model/user_data_model.dart';
import 'package:thopaa/Utils/images.dart';
import 'package:thopaa/Widgets/dropdown.dart';

import '../../export.dart';

class SignUpScreenView extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final bool isOTPLogin;
  final String? uid;
  final int? tokenForOTPCredentials;

  SignUpScreenView(
      {Key? key,
      this.phoneNumber,
      this.isOTPLogin = false,
      this.countryCode,
      this.uid,
      this.tokenForOTPCredentials})
      : super(key: key);

  @override
  _SignUpScreenViewState createState() => _SignUpScreenViewState();
}

class _SignUpScreenViewState extends State<SignUpScreenView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Country selectedCountry = defaultCountry();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController dateCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  bool isAcceptedTc = false;

  bool isFirstTimeValidation = true;

  String? currentAddress;
  String? itemSelected;
  Position? currentPosition;
  late Placemark placeNow;

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.phoneNumber != null) {
      selectedCountry = Country.parse(
          widget.countryCode.validate(value: selectedCountry.countryCode));

      mobileCont.text =
          widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      passwordCont.text =
          widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      userNameCont.text =
          widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      getAddressFromLatLng(position).then((place) {
        setState(() {
          currentAddress =
              '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
          addressCont.text = currentAddress.toString();
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

  //region Logic
  String buildMobileNumber() {
    return '${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
  }

  // Future<void> registerWithOTP() async {
  //   hideKeyboard(context);

  //   if (appStore.isLoading) return;

  //   if (formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     appStore.setLoading(true);

  // UserData userResponse = UserData()
  //   ..username = widget.phoneNumber.validate().trim()
  //   ..loginType = LOGIN_TYPE_OTP
  //   ..contactNumber = buildMobileNumber()
  //   ..email = emailCont.text.trim()
  //   ..firstName = fNameCont.text.trim()
  //   ..lastName = lNameCont.text.trim()
  //   ..userType = USER_TYPE_USER
  //   ..uid = widget.uid.validate()
  //   ..password = widget.phoneNumber.validate().trim();

  // /// Link OTP login with Email Auth
  // if (widget.tokenForOTPCredentials != null) {
  //   try {
  //     AuthCredential credential = PhoneAuthProvider.credentialFromToken(
  //         widget.tokenForOTPCredentials!);
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     AuthCredential emailAuthCredential = EmailAuthProvider.credential(
  //         email: emailCont.text.trim(),
  //         password: DEFAULT_FIREBASE_PASSWORD);
  //     userCredential.user!.linkWithCredential(emailAuthCredential);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // await createUsers(tempRegisterData: userResponse);
  //   }
  // }

  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: language.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),

      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        setState(() {});
      },
    );
  }

  void registerUser() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// If Terms and condition is Accepted then only the user will be registered
      if (isAcceptedTc) {
        appStore.setLoading(true);

        //   /// Create a temporary request to send
        UserData tempRegisterData = UserData()
          ..contactNumber = buildMobileNumber()
          ..firstName = fNameCont.text.trim()
          ..lastName = lNameCont.text.trim()
          ..loginType = LOGIN_TYPE_USER
          ..username = userNameCont.text.trim()
          ..email = emailCont.text.trim()
          ..password = passwordCont.text.trim()
          ..address = addressCont.text
          ..bloodGroup = itemSelected.toString()
          ..cityName = placeNow.administrativeArea.toString();

        createUsers(tempRegisterData: tempRegisterData);
      }
    } else {
      isFirstTimeValidation = false;
      setState(() {});
    }
  }

  Future<void> createUsers({required UserData tempRegisterData}) async {
    await authService
        .signupwithEmailandPassword(
            name: userNameCont.text.trim(),
            email: emailCont.text.trim(),
            password: passwordCont.text.trim())
        .then((value) async {
      if (value == AuthResultStatus.successful) {
        authService.createUser(tempRegisterData);
      } else {
        toast('Something Wrong');
      }

      appStore.setLoading(false);
      await appStore.setLoginType(tempRegisterData.loginType!);

      //   /// Back to sign in screen
      finish(context);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  //endregion

  //region Widget
  Widget _buildTopWidget() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.all(16),
          child: ic_profile2.iconImage(color: Colors.white),
          decoration:
              boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
        ),
        16.height,
        Text(language.lblHelloUser, style: boldTextStyle(size: 22)).center(),
        16.height,
        Text(language.lblSignUpSubTitle,
                style: secondaryTextStyle(size: 14),
                textAlign: TextAlign.center)
            .center()
            .paddingSymmetric(horizontal: 32),
      ],
    );
  }

  Widget _buildFormWidget() {
    setState(() {});
    return Column(
      children: [
        32.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: fNameCont,
          focus: fNameFocus,
          nextFocus: lNameFocus,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintFirstNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: lNameCont,
          focus: lNameFocus,
          nextFocus: userNameFocus,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintLastNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        MyAdvancedDropdown(
          onChanged: (String? value) {
            setState(() {
              itemSelected = value!;
            });
          },
          selectedItem: 'A +ve',
          items: [
            'A +ve',
            'A -ve',
            'B +ve',
            'B -ve',
            'O +ve',
            'O -ve',
            'AB +ve',
            'AB -ve',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Text(
                    value,
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: userNameCont,
          focus: userNameFocus,
          nextFocus: emailFocus,
          readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintUserNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.ADDRESS,
          controller: addressCont,
          focus: addressFocus,
          errorThisFieldRequired: language.requiredText,
          nextFocus: mobileFocus,
          decoration:
              inputDecoration(context, labelText: language.hintAddressTxt),
          suffix:
              ic_active_location.iconImage(size: 21).paddingAll(14).onTap(() {
            getCurrentPosition();
          }),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: dateCont,
          focus: dateFocus,
          errorThisFieldRequired: language.requiredText,
          nextFocus: mobileFocus,
          decoration: inputDecoration(context, labelText: language.hintDateTxt),
          suffix: ic_calendar.iconImage(size: 21).paddingAll(14).onTap(() {
            showDatePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2050))
                .then((DateTime? selected) {
              if (selected != null && selected != selectedDate) {
                setState(() => selectedDate = selected);
                setState(() => dateCont.text =
                    "${selected.year}-${selected.month}-${selected.day}"
                        .toString());
              }
            });
          }),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.EMAIL_ENHANCED,
          controller: emailCont,
          focus: emailFocus,
          errorThisFieldRequired: language.requiredText,
          nextFocus: mobileFocus,
          decoration:
              inputDecoration(context, labelText: language.hintEmailTxt),
          suffix: ic_message.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
          controller: mobileCont,
          focus: mobileFocus,
          buildCounter: (_,
              {required int currentLength,
              required bool isFocused,
              required int? maxLength}) {
            return TextButton(
              child: Text(language.lblChangeCountry,
                  style: primaryTextStyle(size: 12)),
              onPressed: () {
                changeCountry();
              },
            );
          },
          errorThisFieldRequired: language.requiredText,
          nextFocus: passwordFocus,
          decoration: inputDecoration(context,
                  labelText: "${language.hintContactNumberTxt}")
              .copyWith(
            prefixText: '+${selectedCountry.phoneCode} ',
            hintText: '${language.lblExample}: ${selectedCountry.example}',
            hintStyle: secondaryTextStyle(),
          ),
          maxLength: 15,
          suffix: ic_calling.iconImage(size: 10).paddingAll(14),
        ),
        if (!widget.isOTPLogin)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              4.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: passwordCont,
                focus: passwordFocus,
                readOnly:
                    widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
                suffixPasswordVisibleWidget:
                    ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget:
                    ic_hide.iconImage(size: 10).paddingAll(14),
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context,
                    labelText: language.hintPasswordTxt),
                onFieldSubmitted: (s) {
                  // if (widget.isOTPLogin) {
                  //   registerWithOTP();
                  // } else {
                  registerUser();
                  // }
                },
              ),
              20.height,
            ],
          ),
        _buildTcAcceptWidget(),
        8.height,
        AppButton(
          text: language.signUp,
          color: primaryColor,
          textColor: Colors.white,
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            // if (widget.isOTPLogin) {
            //   registerWithOTP();
            // } else {
            registerUser();
            // }
          },
        ),
      ],
    );
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
          isAcceptedTc = !isAcceptedTc;
          setState(() {});
        }),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(
                text: '${language.lblAgree} ', style: secondaryTextStyle()),
            TextSpan(
              text: language.lblTermsOfService,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // commonLaunchUrl(appConfigurationStore.termConditions,
                  //     launchMode: LaunchMode.externalApplication);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: language.privacyPolicy,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // commonLaunchUrl(appConfigurationStore.privacyPolicy,
                  //     launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(
                text: "${language.alreadyHaveAccountTxt} ? ",
                style: secondaryTextStyle()),
            TextSpan(
              text: language.signIn,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
        30.height,
      ],
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: BackWidget(iconColor: context.iconColor),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: isFirstTimeValidation
                  ? AutovalidateMode.disabled
                  : AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTopWidget(),
                    _buildFormWidget(),
                    8.height,
                    _buildFooterWidget(),
                  ],
                ),
              ),
            ),
            Observer(
                builder: (_) =>
                    LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
