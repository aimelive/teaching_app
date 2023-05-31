import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/data/providers/stream_provider.dart';
import 'package:e_connect_mobile/services/app_service.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/classes/teacher_classes_screen.dart';
import 'package:e_connect_mobile/ui/screens/school/school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/controllers/auth.dart';
import '../../../data/models/notification.dart';
import '../../../data/providers/stream_list_provider.dart';
import '../../../utils/app_utils.dart';
import '../../widgets/custom_error_widget.dart';
import '../profile/profile.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});
  final authState = Get.find<AuthState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomBackAppbar(
              title: "Notifications",
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: StreamListProvider<AppNotification>(
                query: Collection.notification
                    .where('to', isEqualTo: authState.user.value!.id),
                fromJson: (json, id) => AppNotification.fromJson(json, id),
                loading: const Text("Loading..."),
                onError: (error) {
                  print(error);
                  return CustomErrorWidget(error: error);
                },
                onSuccess: (notifications) {
                  if (notifications.isEmpty) {
                    return const Text("Empty, there are no notifications yet!");
                  }
                  return Column(
                    children: notifications.map((notification) {
                      return NotificationTile(notification);
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatefulWidget {
  final AppNotification notification;

  const NotificationTile(this.notification, {super.key});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  //Get notification title
  String _getNotificationTitle(String type) {
    switch (type) {
      case "ASSIGN_USER_CLASS":
        return "Assigned to a new class";
      case "UNASSIGN_USER_CLASS":
        return "Unassigned from a class";
      case "ASSIGN_USER_SCHOOL":
        return "Assigned to a new school";
      case "UNASSIGN_USER_SCHOOL":
        return "Unassigned from a school";
      default:
        return "";
    }
  }

  //Get notification direction
  Widget _getNotificationDirection(String type) {
    switch (type) {
      case "ASSIGN_USER_CLASS":
        return StreamProvider<TeacherClass>(
          collectionId: Collection.classesCollectionId,
          docId: widget.notification.data.actionId,
          fromJson: (json) => TeacherClass.fromJson(json),
          loading: Container(),
          onError: (e) => Container(),
          onSuccess: (trClass) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                onPressed: () => pushPage(
                  context,
                  to: TeacherClassesScreen(teacherClass: trClass),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text("View Class"),
              ),
            );
          },
        );
      case "UNASSIGN_USER_CLASS":
        return Container();
      case "ASSIGN_USER_SCHOOL":
        return StreamProvider<School>(
          collectionId: Collection.schoolCollectionId,
          docId: widget.notification.data.actionId,
          fromJson: (json) => School.fromJson(json),
          loading: Container(),
          onError: (e) => Container(),
          onSuccess: (school) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                onPressed: () => pushPage(
                  context,
                  to: SchoolScreen(school: school),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text("View School"),
              ),
            );
          },
        );
      case "UNASSIGN_USER_SCHOOL":
        return Container();
      default:
        return Container();
    }
  }

  void markAsViewed() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        //TODO: mark notification as seen
        AppService().markNotificationAsSeen(widget.notification.id + "nm");
      }
    });
  }

  @override
  void initState() {
    if (!widget.notification.viewed) {
      markAsViewed();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(widget.notification.id),
      background: Container(),
      secondaryBackground: Container(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final delete = await UiUtils.showWarnDialog(
          context,
          title: "Clear Notification",
          subtitle: "Are you sure do you want to clear this notification?",
          okButtonText: "Yes",
        );
        //TODO: Clear the notification.
        AppUtils().clearNotification(widget.notification.id + "nm");
        return delete ?? false;
      },
      child: Container(
        margin: widget.notification.viewed
            ? null
            : EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: widget.notification.viewed
              ? null
              : secondaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7.5),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1a212121),
                    offset: Offset(0, 10),
                    blurRadius: 12,
                    spreadRadius: 0,
                  )
                ],
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Icon(
                Icons.school,
                color: whiteColor,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * (0.05),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTimeAgo(
                        widget.notification.createdAt,
                        enshort: false,
                      ),
                      style: const TextStyle(
                        color: secondaryDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                    addVerticalSpace(2),
                    Text(
                      _getNotificationTitle(widget.notification.data.action),
                      style: const TextStyle(
                        color: secondaryDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                    addVerticalSpace(5),
                    Text(
                      widget.notification.data.message,
                      style: const TextStyle(
                        color: secondaryDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                    addVerticalSpace(5),
                    _getNotificationDirection(widget.notification.data.action)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
