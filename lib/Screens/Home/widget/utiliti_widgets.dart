import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';

class UtilityWidgetHomeScreen extends StatefulWidget {
  const UtilityWidgetHomeScreen({super.key});

  @override
  State<UtilityWidgetHomeScreen> createState() =>
      _UtilityWidgetHomeScreenState();
}

class _UtilityWidgetHomeScreenState extends State<UtilityWidgetHomeScreen> {
  navToBloodbank() {
    BloodBankListScreen().launch(context,
        isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
  }

  navToDonorlist() {
    DonorListScreen().launch(context,
        isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
  }

  final List<String> itemtitle = <String>[
    'Blood Bank',
    'Donor List',
    'Donation Events',
    'HelpLine',
  ];
  final List<String> itemAssets = <String>[
    Assets.bloodbank,
    Assets.donorlist,
    Assets.bloodEvents,
    Assets.helpLine,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.35,
      width: context.width(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('More Utilities', style: sectionTextTitleStyle()),
              Text('View All>>')
            ],
          ),
          10.height,
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            padding: EdgeInsets.all(8.0),
            itemCount: itemtitle.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    navToBloodbank();
                  } else if (index == 1) {
                    navToDonorlist();
                  } else {
                    toast('Service Not Available Now');
                  }
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        itemAssets[index],
                        height: 50,
                      ),
                      Text(
                        itemtitle[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
