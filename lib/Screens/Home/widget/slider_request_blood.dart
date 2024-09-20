import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';

class SliderRequest extends StatelessWidget {
  final String bloodGroup;
  final String location;
  final String patientName;
  final String type;
  final String amount;
  final String date;
  final String diagnosis;
  final String desc;
  final String number;

  const SliderRequest(
      {super.key,
      required this.bloodGroup,
      required this.location,
      required this.patientName,
      required this.type,
      required this.amount,
      required this.date,
      required this.diagnosis,
      required this.desc,
      required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.31,
      width: context.width() * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: blueViolet.withOpacity(0.5),
          image: DecorationImage(image: AssetImage(appLogo), opacity: 0.05),
          border: Border.all(color: black, width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Request Blood:',
                style: boldTextStyle(),
              ),
              5.width,
              Text(
                bloodGroup,
                style: primaryTextStyle(),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: black,
              ),
              5.width,
              Text(
                "Location: ",
                style: boldTextStyle(),
              ),
              Text(
                location,
                style: primaryTextStyle(),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.person_outline_outlined,
                color: black,
              ),
              5.width,
              Text(
                "Patient Name: ",
                style: boldTextStyle(),
              ),
              Text(
                patientName,
                style: primaryTextStyle(),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.type_specimen_outlined,
                    color: black,
                  ),
                  5.width,
                  Text(
                    "Blood Type: ",
                    style: boldTextStyle(),
                  ),
                  Text(
                    type,
                    style: primaryTextStyle(),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_motion_outlined,
                    color: black,
                  ),
                  5.width,
                  Text(
                    "Amount: ",
                    style: boldTextStyle(),
                  ),
                  Text(
                    "${amount} pints",
                    style: primaryTextStyle(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: black,
                  ),
                  5.width,
                  Text(
                    "Needed Date: ",
                    style: boldTextStyle(),
                  ),
                  Text(
                    date,
                    style: primaryTextStyle(),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: black,
                  ),
                  5.width,
                  Text(
                    "Time: ",
                    style: boldTextStyle(),
                  ),
                  Text(
                    date,
                    style: primaryTextStyle(),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.details_outlined,
                color: black,
              ),
              5.width,
              Text(
                "Need For: ",
                style: boldTextStyle(),
              ),
              Text(
                diagnosis,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle(),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: black,
              ),
              5.width,
              Text(
                "Details: ",
                style: boldTextStyle(),
              ),
              Text(
                desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle(),
              ),
            ],
          ),
          5.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Row(
                    children: [
                      Icon(
                        Icons.call,
                        color: black,
                      ),
                      5.width,
                      Text(
                        'Call',
                        style: boldTextStyle(),
                      ),
                    ],
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: black,
                      ),
                      5.width,
                      Text(
                        'Share',
                        style: boldTextStyle(),
                      ),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
