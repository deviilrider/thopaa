import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';

class DonorListScreen extends StatefulWidget {
  const DonorListScreen({super.key});

  @override
  State<DonorListScreen> createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          "Donor List",
          textColor: white,
          textSize: APP_BAR_TEXT_SIZE,
          elevation: 4.0,
          color: context.primaryColor.withOpacity(0.7),
          showBack: true,
          actions: [],
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('DonorList').snapshots(),
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
                              onPressed: () {}
                              // navigateToDetail(snapshot.data[index]),
                              ),
                          onTap: () {
                            // var datas = document.docs[index];
                            // showUserDetails(context, datas);
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          thickness: 2,
                        ));
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text('No any blood bank found'),
                );
              } else {
                return Center(
                  child: Text('Something Wrong'),
                );
              }
            }));
  }
}
