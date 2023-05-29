import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/widgets/error_message_overlay_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

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

  static Future<void> showCustomSnackBar({
    required BuildContext context,
    required String errorMessage,
    required Color backgroundColor,
    Duration delayDuration = errorMessageDisplayDuration,
  }) async {
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
    SnackPosition position = SnackPosition.TOP,
  }) {
    return Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: const Duration(seconds: 4),
      backgroundColor: type == MessageType.normal
          ? primaryColor
          : type == MessageType.error
              ? primaryColor
              : Colors.green.shade400,
      colorText: Colors.white,
    );
  }

  static Future<XFile?> _pickImage(
      ImageSource source, BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
      );
      if (image == null) return null;
      return image;
    } catch (e) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: e.toString(),
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  static Future<XFile?> selectImage(BuildContext context, bool mounted) async {
    final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ImageSource.camera, ImageSource.gallery]
                  .map(
                    (source) => ListTile(
                      onTap: () => popPage(context, data: source),
                      leading: Icon(source == ImageSource.camera
                          ? Icons.photo_camera_outlined
                          : Icons.photo_outlined),
                      title: Text(
                        source == ImageSource.camera
                            ? "Take a photo"
                            : "Choose From Gallery",
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        });
    if (source == null || !mounted) return null;
    final selectedImage = await _pickImage(source, context);
    if (selectedImage == null || !mounted) return null;
    return selectedImage;
  }

  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static Future<void> gotoUrl(String url) async {
    try {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      showMessage(message: e.toString(), title: "Unable to open link.");
    }
  }

  static String date(Timestamp date) {
    return DateFormat('dd MMM yyyy').format(
      date.toDate(),
    );
  }

  static String time(Timestamp time, int duration,
      {bool removeSuffix = false}) {
    final frmt = DateFormat(removeSuffix ? 'hh:mm' : 'hh:mm a');
    return "${frmt.format(time.toDate())} - ${frmt.format(
      time.toDate().add(
            Duration(
              minutes: duration,
            ),
          ),
    )}";
  }

  static bool isToday(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return true;
    }
    return false;
  }

  static bool isThisMonth(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month) {
      return true;
    }
    return false;
  }

  static bool isThisWeek(DateTime dateTime) {
    DateTime now = DateTime.now();
    int currentWeekDay = now.weekday;
    DateTime startDate = now.subtract(
      Duration(days: currentWeekDay),
    );
    DateTime endDate = startDate.add(
      const Duration(days: 7),
    );
    bool isWithinRange =
        dateTime.isAfter(startDate) && dateTime.isBefore(endDate);
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        isWithinRange) {
      return true;
    }
    return false;
  }

  static bool equalDays(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day) {
      return true;
    }
    return false;
  }

  static String dateStatus(Timestamp date) {
    DateTime dateTime = date.toDate();
    DateTime now = DateTime.now();

    if (isToday(dateTime)) {
      return 'Today';
    }

    if (dateTime.isBefore(now)) {
      return timeago.format(dateTime);
    }

    Duration remainingTime = dateTime.difference(now);
    int remainingDays = remainingTime.inDays;
    return '$remainingDays days remaining';
  }

  //Copying to clipboard
  static Future<void> copyToClipboard(BuildContext context, bool mounted,
      {required String text}) async {
    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );
    if (!mounted) return;
    showCustomSnackBar(
      context: context,
      errorMessage: "Copied to clipboard!",
      backgroundColor: secondaryColor,
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
void popPage<T>(BuildContext context, {dynamic data}) =>
    Navigator.pop<T>(context, data);

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
List<String> weekDaysFull = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

getTimeAgo(Timestamp dt, {bool enshort = true}) {
  return timeago.format(
    dt.toDate(),
    allowFromNow: true,
    locale: enshort ? 'en_short' : null,
  );
}

String uniqueId() {
  int size = 28;
  Random random = Random.secure();
  String alphabet =
      'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';
  int len = alphabet.length;
  String id = '';
  while (0 < size--) {
    id += alphabet[random.nextInt(len)];
  }
  return id;
}
