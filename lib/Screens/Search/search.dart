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
                final docData = snapshot.data as DocumentSnapshot;
                return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                          leading: CircleAvatar(
                            child: Text('0'),
                          ),
                          title: Text(
                            docData['displayName'],

                            // 'Name',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Text('Location : '),
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
                          onTap: () {}
                          // => navigateToDetail(snapshot.data[index]),
                          );
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
}
