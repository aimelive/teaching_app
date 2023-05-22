import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/services/user_service.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/home/home.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtils {
  static final userApi = UserService();
  static final hiveUtil = HiveUtils();

  static void login(
    BuildContext context,
    bool mounted, {
    required String email,
    required String pwd,
    required void Function(bool val) onLoading,
  }) async {
    onLoading(true);
    final authState = Get.find<AuthState>();
    if (await hiveUtil.addAuth("fake-token", dummyUser)) {
      authState.user.value = dummyUser;
      if (mounted) {
        pushReplace(
          context,
          to: const HomeScreen(),
        );
      }
    }
    // final data = await userApi.login(email, pwd);

    // if (data != null) {
    //   final userData = await userApi.getUser(email, data["access_token"] ?? "");
    //   if (userData != null) {
    //     if (await hiveUtil.addAuth(data["access_token"], userData)) {
    //       if (mounted) {
    //         pushReplace(
    //           context,
    //           to: const HomeScreen(),
    //         );
    //       }
    //     }
    //   }
    // }
    onLoading(false);
  }
}
