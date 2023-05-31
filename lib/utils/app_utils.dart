import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/controllers/school.dart';
import 'package:e_connect_mobile/data/controllers/teacher_class.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/data/models/user.dart';
import 'package:e_connect_mobile/services/app_service.dart';
import 'package:e_connect_mobile/services/auth_service.dart';
import 'package:e_connect_mobile/services/user_service.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/utils/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/screens/auth/authenticated.dart';

typedef OnLoading = void Function(bool val);

class Collection {
  //Constant collection Ids/paths
  static const userCollectionId = 'users';
  static const schoolCollectionId = 'schools';
  static const chatCollectionId = 'chatMessages';
  static const feedbackCollectionId = 'feedbacks';
  static const classesCollectionId = 'classes';
  static const notificationCollectionId = 'notifications';

  //Getting collection refrence from path
  static CollectionReference<Map<String, dynamic>> collection(String path) {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return fireStore.collection(path);
  }

  //Collection refrences
  static final user = collection(userCollectionId);
  static final chat = collection(chatCollectionId);
  static final school = collection(schoolCollectionId);
  static final classes = collection(classesCollectionId);
  static final feedback = collection(feedbackCollectionId);
  static final notification = collection(notificationCollectionId);
}

class AppUtils {
  static final userApi = UserService();
  static final hiveUtil = HiveUtils();
  static final authService = AuthService();
  static final appService = AppService();

  static void login(
    BuildContext context,
    bool mounted, {
    required String email,
    required String pwd,
    required OnLoading onLoading,
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
              to: const AuthenticatedWrapper(),
            );
          }
        }
      } else {
        if (!mounted) return;
        UiUtils.showCustomSnackBar(
          context: context,
          errorMessage: resp ?? "Something went wrong, please try again.",
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
    required OnLoading onLoading,
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
    required OnLoading onLoading,
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
      if (kDebugMode) {
        print(e);
      }
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Something went wrong, $e, restart the app.",
        backgroundColor: secondaryColor,
      );
    }
  }

  void mapClassesToState(
    List<QueryDocumentSnapshot<Object?>> docs,
    TeacherClassesState state,
    BuildContext context,
    String currentUser,
  ) {
    try {
      final classes = docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return TeacherClass.fromJson(data);
      });
      final filtered = classes.toList();
      filtered.sort((a, b) => a.date.compareTo(b.date));
      state.classes.value = filtered;
      state.todayClasses.value = filtered
          .where((trClass) => UiUtils.isToday(trClass.date.toDate()))
          .toList();
    } catch (e) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Something went wrong, $e, restart the app.",
        backgroundColor: secondaryColor,
      );
    }
  }

  Future<bool> addFeedback(
    BuildContext context,
    bool mounted, {
    required String classId,
    required String feedback,
    required int rate,
    required OnLoading onLoading,
  }) async {
    UiUtils.unfocus(context);
    onLoading(true);
    final result = await appService.addFeedback({
      "classId": classId,
      "feedback": feedback,
      "rate": rate,
      "to": "Teacher Assistant",
    });
    onLoading(false);
    if (result != true && result.runtimeType == String && mounted) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Adding feedback failed: $result",
        backgroundColor: secondaryColor,
      );
      return false;
    }
    UiUtils.showMessage(
      message:
          "Your feedback to teacher assistant has sent to the chief manager successfully,",
      title: "Feedback sent!",
    );
    return true;
  }

  Future<void> clearNotification(String id) async {
    final res = await appService.deleteNotification(id);
    if (res == true) return;
    UiUtils.showMessage(
      message: res ??
          "Something went wrong when we were trying to clear notification",
      title: "Clear Notification Failed",
    );
  }
}
