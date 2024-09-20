import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Screens/Home/widget/slider_request_blood.dart';

class RequestWidgetHomeScreen extends StatefulWidget {
  const RequestWidgetHomeScreen({super.key});

  @override
  State<RequestWidgetHomeScreen> createState() =>
      _RequestWidgetHomeScreenState();
}

class _RequestWidgetHomeScreenState extends State<RequestWidgetHomeScreen> {
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
            children: [Text('Requested Blood'), Text('View All>>')],
          ),
          10.height,
          SliderRequest(
              bloodGroup: 'O +ve',
              location: "CMC",
              patientName: "Subash",
              type: "PRBC",
              amount: "1",
              date: "date",
              diagnosis: "AUB",
              desc: "desc",
              number: "9801019"),
        ],
      ),
    );
  }
}
