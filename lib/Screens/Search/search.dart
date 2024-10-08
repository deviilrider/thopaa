import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';

class SearchBloodGroupScreen extends StatefulWidget {
  final String? bloodGroup;

  const SearchBloodGroupScreen({super.key, this.bloodGroup});

  @override
  State<SearchBloodGroupScreen> createState() => _SearchBloodGroupScreenState();
}

class _SearchBloodGroupScreenState extends State<SearchBloodGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          language.search,
          textColor: white,
          textSize: APP_BAR_TEXT_SIZE,
          elevation: 4.0,
          color: context.primaryColor.withOpacity(0.7),
          showBack: true,
          actions: [],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .where("bloodGroup", isEqualTo: widget.bloodGroup)
                .snapshots(),
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
                      var t = document.docs[index]["last_donated"] as Timestamp;
                      var date = t.toDate();
                      var dateToday = DateTime.now();
                      var difference = dateToday.difference(date).inDays;

                      return ListTile(
                          tileColor: difference > 120
                              ? Colors.green[300]
                              : Colors.red[100],
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: redColor,
                            child: CircleAvatar(
                                radius: 23,
                                child: Text(
                                  document.docs[index]["first_name"][0],
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          title: Text(
                            "${document.docs[index]["first_name"]} ${document.docs[index]["last_name"]} ",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(difference > 120
                              ? "Can Donate"
                              : "Can't Donate Now"),
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
                              onPressed: () {}
                              // navigateToDetail(snapshot.data[index]),
                              ),
                          onTap: () {
                            var datas = document.docs[index];
                            showUserDetails(context, datas);
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          thickness: 2,
                        ));
              } else {
                return Center(
                  child: Text('No users found'),
                );
              }
            }));
  }

  showUserDetails(context, QueryDocumentSnapshot d) {
    var t = d["last_donated"] as Timestamp;
    var dates = t.toDate();
    var dif = DateTime.now().difference(dates).inDays;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Donor Info"),
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
                        url: d['profileUrl'],
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                        radius: 60,
                      ),
                    ),
                  ),
                ),
                Divider(),
                Text("Name: ${d["first_name"]} ${d["last_name"]}"),
                Text("Address: ${d["address"]}"),
                Text("Blood Group: ${d["bloodGroup"]}"),
                Text(
                    "Last Donated: ${dates.year}/${dates.month}/${dates.day} ($dif days back)"),
                d['status'] == "1"
                    ? Text(
                        "Status: Avaliable",
                        style: TextStyle(color: Colors.green[300]),
                      )
                    : Text("Status: Not-Avaliable",
                        style: TextStyle(color: Colors.red[300])),
                Divider(),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                child: Text('Message'),
                onPressed: () {
                  //make screen to go to chat
                },
              ),
              TextButton(
                child: Text('Call'),
                onPressed: () {
                  if (d["showPhone"] == 1) {
                    launchCall("+${d["contact_number"]}");
                  } else {
                    toast(
                        "Contact Number is not available. Please contact admin!!");
                  }
                },
              ),
              TextButton(
                child: Text('Email'),
                onPressed: () {
                  if (d["showEmail"] == 1) {
                    launchMail(d["email"]);
                  } else {
                    toast("Email is private. Please contact admin!!");
                  }
                },
              )
            ],
          );
        });
  }
}
