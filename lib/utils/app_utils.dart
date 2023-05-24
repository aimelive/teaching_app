import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/controllers/school.dart';
import 'package:e_connect_mobile/data/controllers/teacher_class.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
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

  void mapSchoolsToState(List<QueryDocumentSnapshot<Object?>> docs,
      SchoolsState state, BuildContext context, String? currentUser) {
    try {
      if (currentUser == null) return;
      final chats = docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return School.fromJson(data);
      });
      final filtered = chats.toList();
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      state.schools.value = filtered;
    } catch (e) {
      print(e);
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Something went wrong, $e, restart the app.",
        backgroundColor: secondaryColor,
      );
    }
  }

  void mapClassesToState(List<QueryDocumentSnapshot<Object?>> docs,
      TeacherClassesState state, BuildContext context, String? currentUser) {
    try {
      if (currentUser == null) return;
      final classes = docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return TeacherClass.fromJson(data);
      });
      final filtered = classes.toList();
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      state.classes.value = filtered;
    } catch (e) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Something went wrong, $e, restart the app.",
        backgroundColor: secondaryColor,
      );
    }
  }
}
