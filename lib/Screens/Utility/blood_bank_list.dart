import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankListScreen extends StatefulWidget {
  const BloodBankListScreen({super.key});

  @override
  State<BloodBankListScreen> createState() => _BloodBankListScreenState();
}

class _BloodBankListScreenState extends State<BloodBankListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          "Blood Bank List",
          textColor: white,
          textSize: APP_BAR_TEXT_SIZE,
          elevation: 4.0,
          color: context.primaryColor.withOpacity(0.7),
          showBack: true,
          actions: [],
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('BloodBank').snapshots(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text('Loading...'),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                var document = snapshot.data!;
                return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: redColor,
                            child: CircleAvatar(
                                radius: 23,
                                child: Text(
                                  document.docs[index]["bloodbankName"][0],
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          title: Text(
                            "${document.docs[index]["bloodbankName"]}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            "${document.docs[index]["bbnumber"]}",
                          ),
                          trailing: TextButton(
                              // color: kPrimaryColor,
                              // textColor: Colors.white,
                              // padding: EdgeInsets.all(1.0),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(20.0)),
                              child: Text(
                                'Details',
                                textScaleFactor: 1.05,
                              ),
                              onPressed: () {
                                var datas = document.docs[index];
                                showHospitalDetails(context, datas);
                              }),
                          onTap: () {
                            var datas = document.docs[index];
                            showHospitalDetails(context, datas);
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          thickness: 2,
                        ));
              } else {
                return Center(
                  child: Text('No any blood bank found'),
                );
              }
            }));
  }

  showHospitalDetails(context, QueryDocumentSnapshot d) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Blood Bank Info"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    decoration: boxDecorationDefault(
                      border: Border.all(color: primaryColor, width: 3),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: boxDecorationDefault(
                        border: Border.all(
                            color: context.scaffoldBackgroundColor, width: 4),
                        shape: BoxShape.circle,
                      ),
                      child: CachedImageWidget(
                        url: "#",
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                        radius: 60,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Text("Name: ${d["bloodbankName"]}"),
                Text("Address: ${d["address"]}"),
                Text("Description: ${d["desc"]}"),
                Divider(),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                child: Text('Location'),
                onPressed: () {
                  commonLaunchUrl(d['link'],
                      launchMode: LaunchMode.externalApplication);
                  // launchMaps(context, d["bloodbankName"],
                  //     double.parse(d["lat"]), double.parse(d["long"]));
                },
              ),
              TextButton(
                child: Text('Call'),
                onPressed: () {
                  // if (d["bbnumber"] == 1) {
                  launchCall("+977${d["bbnumber"]}");
                  // } else {
                  //   toast(
                  //       "Contact Number is not available. Please contact admin!!");
                  // }
                },
              ),
              TextButton(
                child: Text('Email'),
                onPressed: () {
                  // if (d["bbemail"] == 1) {
                  launchMail(d["bbemail"]);
                  // } else {
                  //   toast("Email is private. Please contact admin!!");
                  // }
                },
              )
            ],
          );
        });
  }
}
