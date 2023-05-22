import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/auth/login_screen.dart';
import 'package:e_connect_mobile/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _bottomMenuHeightAnimationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeInOut)));
  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _bottomMenuHeightAnimationController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeInOut)));

  void startAnimation() async {
    //cupertino page transtion duration
    await Future.delayed(const Duration(milliseconds: 300));

    _bottomMenuHeightAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimation() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
                MediaQuery.of(context).size.height * (0.05)),
        height: MediaQuery.of(context).size.height * (0.4),
        child: Lottie.asset("assets/lottie/onboarding.json"),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
          animation: _bottomMenuHeightAnimationController,
          builder: (context, child) {
            final height = MediaQuery.of(context).size.height *
                    (0.525) *
                    _bottomMenuHeightUpAnimation.value -
                MediaQuery.of(context).size.height *
                    (0.05) *
                    _bottomMenuHeightDownAnimation.value;
            return Container(
              width: MediaQuery.of(context).size.width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: AnimatedSwitcher(
                switchInCurve: Curves.easeInOut,
                duration: const Duration(milliseconds: 400),
                child: _bottomMenuHeightAnimationController.value != 1.0
                    ? const SizedBox()
                    : LayoutBuilder(builder: (context, boxConstraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          (0.1)),
                              child: Text(
                                "E-connect - Teaching Management System",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          (0.1)),
                              child: const Text(
                                "E-connect serves you virtual education at you home",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  color: darkColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.05),
                            ),
                            CustomRoundedButton(
                              onTap: () => pushReplace(
                                context,
                                to: const LoginScreen(),
                              ),
                              widthPercentage: 0.8,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              buttonTitle: "Continue to Login",
                              titleColor: primaryColor,
                              showBorder: true,
                              borderColor: primaryColor,
                            ),
                          ],
                        );
                      }),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          _buildLottieAnimation(),
          _buildBottomMenu(),
        ],
      ),
    );
  }
}
