import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/widgets/error_message_overlay_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

enum MessageType { normal, success, error }

//error message display duration
const Duration errorMessageDisplayDuration = Duration(milliseconds: 3000);

class UiUtils {
  static Future<dynamic> showBottomSheet(
      {required Widget child,
      required BuildContext context,
      bool? enableDrag}) async {
    final result = await showModalBottomSheet(
      enableDrag: enableDrag ?? false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      context: context,
      builder: (_) => child,
    );

    return result;
  }

  static Future<void> showCustomSnackBar(
      {required BuildContext context,
      required String errorMessage,
      required Color backgroundColor,
      Duration delayDuration = errorMessageDisplayDuration}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => ErrorMessageOverlayContainer(
        backgroundColor: backgroundColor,
        errorMessage: errorMessage,
      ),
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(delayDuration);
    overlayEntry.remove();
  }

  static SnackbarController showMessage({
    required String message,
    required String title,
    MessageType type = MessageType.normal,
  }) {
    return Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      backgroundColor: type == MessageType.normal
          ? primaryColor
          : type == MessageType.error
              ? primaryColor
              : Colors.green.shade400,
      colorText: Colors.white,
    );
  }
}

/// Navigating to another page by material page route
dynamic pushPage(BuildContext context,
    {required Widget to, bool? asDialog}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => to,
      fullscreenDialog: asDialog != null,
    ),
  );
}

/// Navigating to another page by material page route
dynamic pushReplace(BuildContext context,
    {required Widget to, bool? asDialog}) async {
  return await Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => to,
      fullscreenDialog: asDialog != null,
    ),
  );
}

/// Popping the current material page route from the queue
void popPage(BuildContext context, {dynamic data}) =>
    Navigator.pop(context, data);

/// Adding horizontal space in a row
SizedBox addHorizontalSpace(double width) {
  return SizedBox(width: width.w);
}

/// Adding vertical space in a row
SizedBox addVerticalSpace(double height) {
  return SizedBox(height: height.h);
}

//Capitalize first letter of a word
String cfl(String str) {
  if (str.isEmpty) return str;
  if (str.length == 1) return str.toUpperCase();
  return str[0].toUpperCase() + str.substring(1).toLowerCase();
}

/// Getting assests image path
String getImagePath(String imageName) {
  return "assets/images/$imageName";
}

/// Getting assests icon path
String getIconPath(String iconName) {
  return "assets/icons/$iconName.svg";
}

List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

getTimeAgo(Timestamp dt) {
  return timeago.format(dt.toDate(), allowFromNow: true, locale: 'en_short');
}
