import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Screens/Home/widget/request_widget.dart';
import 'package:thopaa/Screens/Home/widget/utiliti_widgets.dart';
import 'package:thopaa/Screens/Search/search.dart';
import 'package:thopaa/Widgets/dropdown.dart';
import 'package:thopaa/export.dart';

class HomeFragmentView extends StatefulWidget {
  const HomeFragmentView({super.key});

  @override
  State<HomeFragmentView> createState() => _HomeFragmentViewState();
}

class _HomeFragmentViewState extends State<HomeFragmentView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController bloodGroup = TextEditingController();
  TextEditingController district = TextEditingController();

  FocusNode bloodGroupFocus = FocusNode();
  FocusNode districtFocus = FocusNode();
  String? itemSelected;

  @override
  void initState() {
    super.initState();
    init();

    setStatusBarColor(transparentColor, delayInMilliSeconds: 800);

    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      init();
      appStore.setLoading(true);

      setState(() {});
    });
  }

  void init() async {
    // future = userDashboard(
    //     isCurrentLocation: appStore.isCurrentLocation,
    //     lat: getDoubleAsync(LATITUDE),
    //     long: getDoubleAsync(LONGITUDE));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.46,
                  child: Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            )),
                        child: Column(
                          children: [
                            (context.statusBarHeight).toInt().height,
                            AppbarDashboardComponent(
                              callback: () async {
                                appStore.setLoading(true);
                                init();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 130,
                        left: size.width * 0.05,
                        right: size.width * 0.05,
                        child: Container(
                            height: 250,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20)),
                            child: Form(
                                key: formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(16),
                                  child: Observer(builder: (context) {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          20.height,
                                          Text(
                                            'Select Blood Group',
                                            style: boldTextStyle(),
                                          ),
                                          20.height,
                                          AutofillGroup(
                                              child: Column(
                                            children: [
                                              16.height,
                                              MyAdvancedDropdown(
                                                onChanged: (String? value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      itemSelected = value;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      itemSelected = 'A +ve';
                                                    });
                                                  }
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
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          value,
                                                          style:
                                                              secondaryTextStyle(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              30.height,
                                              AppButton(
                                                text: language.search,
                                                color: primaryColor,
                                                textColor: Colors.white,
                                                width: context.width() * 0.5,
                                                onTap: () {
                                                  SearchBloodGroupScreen(
                                                    bloodGroup: itemSelected,
                                                  ).launch(context,
                                                      isNewTask: false,
                                                      pageRouteAnimation:
                                                          PageRouteAnimation
                                                              .Fade);
                                                },
                                              ),
                                            ],
                                          ))
                                        ]);
                                  }),
                                ))),
                      ),
                    ],
                  ),
                ),
                5.height,
                RequestWidgetHomeScreen(),
                20.height,
                UtilityWidgetHomeScreen(),
                20.height,
              ],
            ),
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
