import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/auth/widgets/forgot_pwd_bottomsheet.dart';
import 'package:e_connect_mobile/ui/widgets/custom_button.dart';
import 'package:e_connect_mobile/ui/widgets/custom_circular_progress.dart';
import 'package:e_connect_mobile/ui/widgets/custom_textfield.dart';
import 'package:e_connect_mobile/ui/widgets/password_hide_show_button.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));

  late final Animation<double> _patterntAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)));

  late final Animation<double> _formAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)));

  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  bool _hidePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();

    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  void _signInUser() {
    final email = _emailTextEditingController.text.trim();
    final pwd = _passwordTextEditingController.text.trim();
    if (email.isEmpty) {
      UiUtils.showCustomSnackBar(
          context: context,
          errorMessage: "Please enter your email",
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }

    if (pwd.isEmpty) {
      UiUtils.showCustomSnackBar(
          context: context,
          errorMessage: "Please enter your passowrd",
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }

    AppUtils.login(context, mounted, email: email, pwd: pwd,
        onLoading: (value) {
      if (!mounted) return;
      setState(() {
        _isLoading = value;
      });
    });
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GestureDetector(
          onTap: () {
            UiUtils.showBottomSheet(
              child: const ForgotPasswordRequestBottomsheet(),
              context: context,
            ).then((value) {
              if (value != null && !value['error']) {
                UiUtils.showCustomSnackBar(
                  context: context,
                  errorMessage:
                      "Reset password link sent to your email: ${value['email']}",
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                );
              }
            });
          },
          child: Text(
            "Forgot password?",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildUpperPattern() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: FadeTransition(
        opacity: _patterntAnimation,
        child: SlideTransition(
          position: _patterntAnimation.drive(
              Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)),
          child: Image.asset(
            getImagePath("upper_pattern.png"),
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLowerPattern() {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: FadeTransition(
        opacity: _patterntAnimation,
        child: SlideTransition(
            position: _patterntAnimation.drive(
                Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)),
            child: Image.asset(
              getImagePath("lower_pattern.png"),
              color: primaryColor,
            )),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: FadeTransition(
        opacity: _formAnimation,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: NotificationListener(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (0.075),
                  right: MediaQuery.of(context).size.width * (0.075),
                  top: MediaQuery.of(context).size.height * (0.25)),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Let's Sign In",
                      style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      "Welcome back, \nYou have been missed",
                      style: TextStyle(
                        fontSize: 24.0,
                        height: 1.5,
                        color: secondaryDark,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    CustomTextFieldContainer(
                      hideText: false,
                      hintText: "Email",
                      bottomPadding: 0,
                      textEditingController: _emailTextEditingController,
                      suffixWidget: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          getImagePath("mail_icon.svg"),
                          // color: secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomTextFieldContainer(
                      hideText: _hidePassword,
                      hintText: "Password",
                      bottomPadding: 0,
                      textEditingController: _passwordTextEditingController,
                      suffixWidget: PasswordHideShowButton(
                          hidePassword: _hidePassword,
                          onTap: () {
                            _hidePassword = !_hidePassword;
                            setState(() {});
                          }),
                    ),
                    _buildForgotPassword(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: CustomRoundedButton(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          if (_isLoading) return;
                          _signInUser();
                        },
                        widthPercentage: 0.8,
                        backgroundColor: primaryColor,
                        buttonTitle: "Sign In",
                        titleColor: Theme.of(context).scaffoldBackgroundColor,
                        showBorder: false,
                        child: _isLoading
                            ? const CustomCircularProgressIndicator(
                                strokeWidth: 2,
                                widthAndHeight: 20,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),

                    // TermsAndConditionAndPrivacyPolicyContainer(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildUpperPattern(),
          _buildLowerPattern(),
          _buildLoginForm(),
        ],
      ),
    );
  }
}
