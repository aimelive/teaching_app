import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/auth/welcome_screen.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  void showLogOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text("Are you sure you want to log out?"),
              actions: [
                CupertinoButton(
                    child: const Text("Yes"),
                    onPressed: () async {
                      await HiveUtils().removeAuth();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const WelcomeScreen()),
                        (route) => false,
                      );
                    }),
                CupertinoButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          showLogOutDialog(context);
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: MediaQuery.of(context).size.width * (0.4),
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).colorScheme.secondary),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 16,
                    width: 16,
                    child: SvgPicture.asset(getImagePath("logout_icon.svg"))),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Logout",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
