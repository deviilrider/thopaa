import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Server/firebase.dart';
import 'package:thopaa/Server/handler/auth_result_handler.dart';
import 'package:thopaa/export.dart';

class SignInScreenView extends StatefulWidget {
  const SignInScreenView({super.key});

  @override
  State<SignInScreenView> createState() => _SignInScreenViewState();
}

class _SignInScreenViewState extends State<SignInScreenView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isRemember = true;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isRemember = getBoolAsync(IS_REMEMBERED);
    if (isRemember) {
      emailCont.text = getStringAsync(USER_EMAIL);
      passwordCont.text = getStringAsync(USER_PASSWORD);
    }
  }

  //region Methods

  void _handleLogin() {
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _handleLoginUsers();
    }
  }

  void _handleLoginUsers() async {
    hideKeyboard(context);

    appStore.setLoading(true);
    try {
      // final loginResponse = await loginUser(request, isSocialLogin: false);

      await setValue(USER_PASSWORD, passwordCont.text);
      await setValue(IS_REMEMBERED, isRemember);
      await appStore.setLoginType(LOGIN_TYPE_USER);

      authService
          .login(email: emailCont.text.trim(), pass: passwordCont.text.trim())
          .then((value) async {
        if (value == AuthResultStatus.successful) {
          // authService.verifyFirebaseUser();
          TextInput.finishAutofillContext();
          appStore.setLoggedIn(true);

          onLoginSuccessRedirection();
        } else {
          toast('Something Wrong');
        }
      });
    } catch (e) {
      appStore.setLoading(false);
      toast(e.toString());
    }
  }

  void googleSignIn() async {
    appStore.setLoading(true);
    // await authService.signInWithGoogle(context).then((googleUser) async {
    //   String firstName = '';
    //   String lastName = '';
    //   if (googleUser.displayName.validate().split(' ').length >= 1) firstName = googleUser.displayName.splitBefore(' ');
    //   if (googleUser.displayName.validate().split(' ').length >= 2) lastName = googleUser.displayName.splitAfter(' ');

    //   Map<String, dynamic> request = {
    //     'first_name': firstName,
    //     'last_name': lastName,
    //     'email': googleUser.email,
    //     'username': googleUser.email.splitBefore('@').replaceAll('.', '').toLowerCase(),
    //     'password': passwordCont.text.trim(),
    //     'social_image': googleUser.photoURL,
    //     'login_type': LOGIN_TYPE_GOOGLE,
    //   };
    //   var loginResponse = await loginUser(request, isSocialLogin: true);

    //   loginResponse.userData!.profileImage = googleUser.photoURL.validate();

    //   await saveUserData(loginResponse.userData!);
    //   appStore.setLoginType(LOGIN_TYPE_GOOGLE);

    //   authService.verifyFirebaseUser();

    //   onLoginSuccessRedirection();
    //   appStore.setLoading(false);
    // }).catchError((e) {
    //   appStore.setLoading(false);
    //   toast(e.toString());
    // });
  }

  // void appleSign() async {
  //   appStore.setLoading(true);

  //   await authService.appleSignIn().then((req) async {
  //     await loginUser(req, isSocialLogin: true).then((value) async {
  //       await saveUserData(value.userData!);
  //       appStore.setLoginType(LOGIN_TYPE_APPLE);

  //       appStore.setLoading(false);
  //       authService.verifyFirebaseUser();

  //       onLoginSuccessRedirection();
  //     }).catchError((e) {
  //       appStore.setLoading(false);
  //       log(e.toString());
  //       throw e;
  //     });
  //   }).catchError((e) {
  //     appStore.setLoading(false);
  //     toast(e.toString());
  //   });
  // }

  // void otpSignIn() async {
  //   hideKeyboard(context);

  //   OTPLoginScreen().launch(context);
  // }

  void onLoginSuccessRedirection() {
    afterBuildCreated(() {
      appStore.setLoading(false);
      // if (widget.isFromServiceBooking.validate() || widget.isFromDashboard.validate() || widget.returnExpected.validate()) {
      //   if (widget.isFromDashboard.validate()) {
      //     push(DashboardScreen(redirectToBooking: true), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      //   } else {
      //     finish(context, true);
      //   }
      // } else {
      HomeScreenView().launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      // }
    });
  }

//endregion

//region Widgets
  Widget _buildTopWidget() {
    return Container(
      child: Column(
        children: [
          Text("${language.lblLoginTitle}!", style: boldTextStyle(size: 20))
              .center(),
          16.height,
          Text(language.lblLoginSubTitle,
                  style: primaryTextStyle(size: 14),
                  textAlign: TextAlign.center)
              .center()
              .paddingSymmetric(horizontal: 32),
          32.height,
        ],
      ),
    );
  }

  Widget _buildRememberWidget() {
    return Column(
      children: [
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedCheckBox(
              borderColor: context.primaryColor,
              checkedColor: context.primaryColor,
              isChecked: isRemember,
              text: language.rememberMe,
              textStyle: secondaryTextStyle(),
              size: 20,
              onTap: (value) async {
                await setValue(IS_REMEMBERED, isRemember);
                isRemember = !isRemember;
                setState(() {});
              },
            ),
            TextButton(
              onPressed: () {
                showInDialog(context,
                    contentPadding: EdgeInsets.zero,
                    dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                    builder: (_) {}
                    // => ForgotPasswordScreen(),
                    );
              },
              child: Text(
                language.forgotPassword,
                style: boldTextStyle(
                    color: primaryColor, fontStyle: FontStyle.italic),
                textAlign: TextAlign.right,
              ),
            ).flexible(),
          ],
        ),
        24.height,
        AppButton(
          text: language.signIn,
          color: primaryColor,
          textColor: Colors.white,
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            _handleLogin();
            // HomeScreenView().launch(context,
            //     isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
          },
        ),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(language.doNotHaveAccount, style: secondaryTextStyle()),
            TextButton(
              onPressed: () {
                hideKeyboard(context);
                SignUpScreenView().launch(context);
              },
              child: Text(
                language.signUp,
                style: boldTextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildSocialWidget() {
  // if (appConfigurationStore.socialLoginStatus) {
  //   return Column(
  //     children: [
  //       20.height,
  //       if ((appConfigurationStore.googleLoginStatus || appConfigurationStore.otpLoginStatus) || (isIOS && appConfigurationStore.appleLoginStatus))
  //         Row(
  //           children: [
  //             Divider(color: context.dividerColor, thickness: 2).expand(),
  //             16.width,
  //             Text(language.lblOrContinueWith, style: secondaryTextStyle()),
  //             16.width,
  //             Divider(color: context.dividerColor, thickness: 2).expand(),
  //           ],
  //         ),
  //       24.height,
  //       if (appConfigurationStore.googleLoginStatus)
  //         AppButton(
  //           text: '',
  //           color: context.cardColor,
  //           padding: EdgeInsets.all(8),
  //           textStyle: boldTextStyle(),
  //           width: context.width() - context.navigationBarHeight,
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(12),
  //                 decoration: boxDecorationWithRoundedCorners(
  //                   backgroundColor: primaryColor.withOpacity(0.1),
  //                   boxShape: BoxShape.circle,
  //                 ),
  //                 child: GoogleLogoWidget(size: 16),
  //               ),
  //               Text(language.lblSignInWithGoogle, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
  //             ],
  //           ),
  //           onTap: googleSignIn,
  //         ),
  //       if (appConfigurationStore.googleLoginStatus) 16.height,
  //       if (appConfigurationStore.otpLoginStatus)
  //         AppButton(
  //           text: '',
  //           color: context.cardColor,
  //           padding: EdgeInsets.all(8),
  //           textStyle: boldTextStyle(),
  //           width: context.width() - context.navigationBarHeight,
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(8),
  //                 decoration: boxDecorationWithRoundedCorners(
  //                   backgroundColor: primaryColor.withOpacity(0.1),
  //                   boxShape: BoxShape.circle,
  //                 ),
  //                 child: ic_calling.iconImage(size: 18, color: primaryColor).paddingAll(4),
  //               ),
  //               Text(language.lblSignInWithOTP, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
  //             ],
  //           ),
  //           onTap: otpSignIn,
  //         ),
  //       if (appConfigurationStore.otpLoginStatus) 16.height,
  //       if (isIOS)
  //         if (appConfigurationStore.appleLoginStatus)
  //           AppButton(
  //             text: '',
  //             color: context.cardColor,
  //             padding: EdgeInsets.all(8),
  //             textStyle: boldTextStyle(),
  //             width: context.width() - context.navigationBarHeight,
  //             child: Row(
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.all(8),
  //                   decoration: boxDecorationWithRoundedCorners(
  //                     backgroundColor: primaryColor.withOpacity(0.1),
  //                     boxShape: BoxShape.circle,
  //                   ),
  //                   child: Icon(Icons.apple),
  //                 ),
  //                 Text(language.lblSignInWithApple, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
  //               ],
  //             ),
  //             onTap: appleSign,
  //           ),
  //     ],
  //   );
  // } else {
  //   return Offstage();
  // }
  // }

//endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // if (widget.isFromServiceBooking.validate()) {
    //   setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
    // } else if (widget.isFromDashboard.validate()) {
    //   setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);
    // } else {
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: Navigator.of(context).canPop()
            ? BackWidget(iconColor: context.iconColor)
            : null,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: Body(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Observer(builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (context.height() * 0.05).toInt().height,
                  _buildTopWidget(),
                  AutofillGroup(
                    child: Column(
                      children: [
                        AppTextField(
                          textFieldType: TextFieldType.EMAIL_ENHANCED,
                          controller: emailCont,
                          focus: emailFocus,
                          nextFocus: passwordFocus,
                          errorThisFieldRequired: language.requiredText,
                          decoration: inputDecoration(context,
                              labelText: language.hintEmailTxt),
                          suffix: ic_message.iconImage(size: 10).paddingAll(14),
                          autoFillHints: [AutofillHints.email],
                        ),
                        16.height,
                        AppTextField(
                          textFieldType: TextFieldType.PASSWORD,
                          controller: passwordCont,
                          focus: passwordFocus,
                          suffixPasswordVisibleWidget:
                              ic_show.iconImage(size: 10).paddingAll(14),
                          suffixPasswordInvisibleWidget:
                              ic_hide.iconImage(size: 10).paddingAll(14),
                          decoration: inputDecoration(context,
                              labelText: language.hintPasswordTxt),
                          autoFillHints: [AutofillHints.password],
                          onFieldSubmitted: (s) {
                            _handleLogin();
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildRememberWidget(),
                  // if (!getBoolAsync(HAS_IN_REVIEW)) _buildSocialWidget(),
                  30.height,
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
