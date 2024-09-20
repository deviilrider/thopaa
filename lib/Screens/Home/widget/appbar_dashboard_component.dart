import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/export.dart';

class AppbarDashboardComponent extends StatefulWidget {
  final VoidCallback? callback;

  AppbarDashboardComponent({this.callback});

  @override
  State<AppbarDashboardComponent> createState() =>
      _AppbarDashboardComponentState();
}

class _AppbarDashboardComponentState extends State<AppbarDashboardComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (appStore.isLoggedIn)
          CachedImageWidget(
            url: appStore.userProfileImage.validate(),
            height: 44,
            width: 44,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(100).paddingRight(16),
        Row(
          children: [
            Text(
              appStore.isLoggedIn
                  ? appStore.userFirstName
                  : language.helloGuest,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: boldTextStyle(),
            ),
            appStore.isLoggedIn
                ? Offstage()
                : Image.asset(ic_hi, height: 20, fit: BoxFit.cover),
          ],
        ).expand(),
        16.width,
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 5, vertical: appStore.unreadCount > 0 ? 10 : 8),
          decoration: boxDecorationDefault(
            color: context.cardColor,
            borderRadius: radius(20),
          ),
          child: Row(
            children: [
              if (appStore.isLoggedIn)
                Container(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ic_notification
                          .iconImage(
                            size: 20,
                          )
                          .center(),
                      if (appStore.unreadCount.validate() > 0)
                        Observer(builder: (context) {
                          return Positioned(
                            top: -2,
                            right: 2,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: boxDecorationDefault(
                                  color: Colors.red, shape: BoxShape.circle),
                            ),
                          );
                        })
                    ],
                  ),
                ).paddingLeft(1).onTap(() {
                  // NotificationScreen().launch(context);
                })
            ],
          ),
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
