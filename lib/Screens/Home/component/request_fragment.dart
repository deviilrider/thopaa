import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';

class RequestScreenView extends StatefulWidget {
  const RequestScreenView({super.key});

  @override
  State<RequestScreenView> createState() => _RequestScreenViewState();
}

class _RequestScreenViewState extends State<RequestScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.requestBlood,
        textColor: white,
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 4.0,
        color: context.primaryColor.withOpacity(0.7),
        showBack: false,
        actions: [
          // IconButton(
          //   icon: ic_setting.iconImage(color: white, size: 20),
          //   onPressed: () async {
          //     // SettingScreen().launch(context);
          //   },
          // ),
        ],
      ),
      floatingActionButton: IconButton(
          icon: CircleAvatar(
            radius: 28,
            backgroundColor: primaryColor.withOpacity(0.7),
            child: CircleAvatar(
                radius: 25,
                backgroundColor: grey,
                child: Icon(
                  Icons.add_moderator,
                  color: primaryColor,
                )),
          ),
          onPressed: () {
            RequestFormView().launch(context,
                isNewTask: false, pageRouteAnimation: PageRouteAnimation.Fade);
          }),
      body: Center(
        child: Text('Hi'),
      ),
    );
  }
}
