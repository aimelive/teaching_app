import 'dart:io';

import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/services/auth_service.dart';
import 'package:e_connect_mobile/services/user_service.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/home/home.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtils {
  static final userApi = UserService();
  static final hiveUtil = HiveUtils();
  static final authService = AuthService();

  static void login(
    BuildContext context,
    bool mounted, {
    required String email,
    required String pwd,
    required void Function(bool val) onLoading,
  }) async {
    onLoading(true);
    final authState = Get.find<AuthState>();
    final result = await authService.signIn(email, pwd);
    if (result.runtimeType == User) {
      User user = result;
      final resp = await authService.getUser(user.uid);
      if (resp.runtimeType == UserAccount) {
        if (await hiveUtil.addAuth(user.refreshToken ?? "dummy-token", resp)) {
          authState.user.value = resp;
          if (mounted) {
            pushReplace(
              context,
              to: const HomeScreen(),
            );
          }
        }
      } else {
        if (!mounted) return;
        UiUtils.showCustomSnackBar(
          context: context,
          errorMessage: result.toString(),
          backgroundColor: primaryColor,
        );
      }
    } else {
      if (!mounted) return;
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: result,
        backgroundColor: primaryColor,
      );
    }

    // if (await hiveUtil.addAuth("fake-token", dummyUser)) {
    //   authState.user.value = dummyUser;
    //   if (mounted) {
    //     pushReplace(
    //       context,
    //       to: const HomeScreen(),
    //     );
    //   }
    // }
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

  static void resetPWd(
    BuildContext context,
    bool mounted, {
    required String email,
    required void Function(bool val) onLoading,
  }) async {
    onLoading(true);
    final result = await authService.forgotPassword(email);
    if (!mounted) return;
    if (result == true) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Reset email link sent!",
        backgroundColor: primaryColor,
      );
      popPage(context);
    } else {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: result,
        backgroundColor: primaryColor,
      );
    }
    onLoading(false);
  }

  Future<String?> uploadFile(
    BuildContext context,
    String message,
    File image, {
    required void Function(bool val) onLoading,
    required void Function(String val) onSuccess,
  }) async {
    onLoading(true);
    try {
      final reference = FirebaseStorage.instance.ref().child(message);
      final uploadTask = await reference.putFile(image);
      final url = await uploadTask.ref.getDownloadURL();
      onSuccess(url);
      return url;
    } catch (e) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: e.toString(),
        backgroundColor: Colors.red,
      );
      return null;
    } finally {
      onLoading(false);
    }
  }
}
