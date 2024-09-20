import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';

class ChatFragmentView extends StatefulWidget {
  const ChatFragmentView({super.key});

  @override
  State<ChatFragmentView> createState() => _ChatFragmentViewState();
}

class _ChatFragmentViewState extends State<ChatFragmentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          language.lblChat,
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
        body: Center(
          child: Text('Hi'),
        ));
  }
}
