import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Server/firebase.dart';
import 'package:thopaa/Model/request_data.dart';
import 'package:thopaa/Widgets/dropdown.dart';
import 'package:thopaa/export.dart';

class RequestFormView extends StatefulWidget {
  final String? countryCode;
  RequestFormView({
    Key? key,
    this.countryCode,
  }) : super(key: key);

  @override
  State<RequestFormView> createState() => _RequestFormViewState();
}

class _RequestFormViewState extends State<RequestFormView> {
  // @override
  // Widget build(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Country selectedCountry = defaultCountry();

  TextEditingController ptfirstName = TextEditingController();
  TextEditingController ptlastName = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController dateCont = TextEditingController();
  TextEditingController timeCont = TextEditingController();
  TextEditingController bloodTypeCont = TextEditingController();
  TextEditingController bloodAmtCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController bloodRqdCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController priority = TextEditingController();

  FocusNode ptfNameFocus = FocusNode();
  FocusNode ptlastNameFocus = FocusNode();
  FocusNode bloodTypeFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode timeFocus = FocusNode();
  FocusNode bloodAmtFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode bloodRqdFocus = FocusNode();
  FocusNode descFocus = FocusNode();

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  bool isAcceptedTc = false;

  bool isFirstTimeValidation = true;

  String? currentAddress;
  String? itemSelected;
  Position? currentPosition;
  late Placemark placeNow;
  double lat = 27.80;
  double long = 85.02;

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getCurrentPosition();
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
          lat = currentPosition!.latitude;
          long = currentPosition!.longitude;
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

  void addRequest() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// If Terms and condition is Accepted then only the user will be registered
      //     if (isAcceptedTc) {
      appStore.setLoading(true);

      //   /// Create a temporary request to send
      RequestBloodData reqTemp = RequestBloodData()
        ..ptfirstName = ptfirstName.text.trim()
        ..ptlastName = ptlastName.text.trim()
        ..bloodGroup = itemSelected.toString()
        ..bloodType = bloodTypeCont.text.trim()
        ..bloodAmount = bloodAmtCont.text.trim()
        ..address = addressCont.text
        ..requiredDate = selectedDate
        ..needTime = selectedTime
        ..contactNumber = mobileCont.text.trim()
        ..needFor = bloodRqdCont.text.trim()
        ..description = descCont.text.trim()
        ..priority = priority.text.trim()
        ..lat = lat
        ..long = long;

      requestBloodData(tempData: reqTemp);
    } else {
      isFirstTimeValidation = false;
      setState(() {});
    }
  }

  Future<void> requestBloodData({required RequestBloodData tempData}) async {
    if (tempData.ptfirstName != null) {
      authService.requestBloodDonor(tempData).then((value) {
        appStore.setLoading(false);
      });
    } else {
      toast('Something Wrong');
    }
  }

  //endregion

  Widget _buildFormWidget() {
    setState(() {});
    return Column(
      children: [
        32.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: ptfirstName,
          focus: ptfNameFocus,
          nextFocus: ptlastNameFocus,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintptFirstNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: ptlastName,
          focus: ptlastNameFocus,
          nextFocus: addressFocus,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintptLastNameTxt),
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
        MyAdvancedDropdown(
          onChanged: (String? value) {
            setState(() {
              bloodTypeCont.text = value!;
            });
          },
          selectedItem: 'Whole Blood',
          items: [
            'Whole Blood',
            'PRBC/PCV',
            'FFP',
            'PRP',
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
          controller: bloodAmtCont,
          focus: bloodAmtFocus,
          nextFocus: bloodRqdFocus,
          readOnly: false,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.bloodRequiredAmount),
          suffix: ic_coupon_prefix.iconImage(size: 10).paddingAll(14),
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
          decoration:
              inputDecoration(context, labelText: language.requiredDateTxt),
          suffix: ic_calendar.iconImage(size: 21).paddingAll(14).onTap(() {
            showDatePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2050))
                .then((DateTime? selected) {
              if (selected != null && selected != selectedDate) {
                setState(() => selectedDate = selected);
                setState(() => dateCont.text =
                    "${selected.year}-${selected.month}-${selected.day}, ${selected.weekday == 1 ? "Monday" : selected.weekday == 2 ? "Tuesday" : selected.weekday == 3 ? "Wednesday" : selected.weekday == 4 ? "Thursday" : selected.weekday == 5 ? "Friday" : selected.weekday == 6 ? "Saturday" : "Sunday"}"
                        .toString());
              }
            });
          }),
        ),
        16.height,
        AppTextField(
            textFieldType: TextFieldType.NAME,
            controller: timeCont,
            focus: timeFocus,
            errorThisFieldRequired: language.requiredText,
            nextFocus: mobileFocus,
            decoration:
                inputDecoration(context, labelText: language.requiredTimeTxt),
            suffix: ic_clock.iconImage(size: 21).paddingAll(14).onTap(() {
              showTimePicker(context: context, initialTime: TimeOfDay.now())
                  .then((selectedT) {
                if (selectedT != null && selectedT != selectedTime) {
                  setState(() => selectedTime = selectedT);
                  setState(() => timeCont.text =
                      "${selectedT.hour}:${selectedT.minute} ${selectedT.hourOfPeriod == 1 ? " AM" : "PM"}"
                          .toString());
                }
                ;
              });
            })),
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
          nextFocus: bloodTypeFocus,
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
        16.height,
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: bloodRqdCont,
          focus: bloodRqdFocus,
          nextFocus: descFocus,
          readOnly: false,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.bloodRequiredFor),
          suffix: ic_document.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: descCont,
          focus: descFocus,
          // nextFocus: emailFocus,
          readOnly: false,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintDescription),
          suffix: ic_document.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        MyAdvancedDropdown(
          onChanged: (String? value) {
            setState(() {
              priority.text = value!;
            });
          },
          selectedItem: 'Urgent',
          items: [
            'Urgent',
            'Non-urgent',
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
        20.height,
        AppButton(
          text: language.requestBlood,
          color: primaryColor,
          textColor: Colors.white,
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            // if (widget.isOTPLogin) {
            //   registerWithOTP();
            // } else {
            // registerUser();
            // }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.requestBlood,
        textColor: white,
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 4.0,
        color: context.primaryColor.withOpacity(0.7),
        showBack: true,
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
                    _buildFormWidget(),
                    8.height,
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
