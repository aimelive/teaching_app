import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/models/notification.dart';
import 'package:e_connect_mobile/services/app_service.dart';
import 'package:e_connect_mobile/services/class_services.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/classes/teacher_classes_screen.dart';
import 'package:e_connect_mobile/ui/screens/school/school.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationUtils {
  static Future<void> setUpNotificationService(
      BuildContext buildContext, bool mounted) async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();

    //ask for permission
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      //if permission is provisionnal or authorised
      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.provisional) {
        if (!mounted) return;
        initNotificationListener(buildContext, mounted);
      }

      //if permission denied
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      return;
    }
    if (!mounted) return;
    initNotificationListener(buildContext, mounted);
  }

  static void initNotificationListener(
      BuildContext buildContext, bool mounted) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(foregroundMessageListener);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      onMessageOpenedAppListener(remoteMessage, buildContext, mounted);
    });
  }

  static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
    final data = NotificationData.fromJson(remoteMessage.data);
    notify(
      AppNotification(
        id: remoteMessage.data["notificationId"] ?? "none-none",
        createdAt: Timestamp.now(),
        data: data,
        viewed: false,
        to: "this-user",
      ),
    );
  }

  static void foregroundMessageListener(RemoteMessage remoteMessage) async {
    final notification = AppNotification(
      id: remoteMessage.data["notificationId"] ?? "none-none",
      createdAt: Timestamp.now(),
      data: NotificationData.fromJson(remoteMessage.data),
      viewed: false,
      to: "this-user",
    );
    notify(notification);
    UiUtils.showMessage(
      message: notification.data.message,
      title: "New Notification",
    );
  }

  static Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      foregroundMessageListener(initialMessage);
    }
  }

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'reminders',
          channelKey: 'instant_notification',
          channelName: 'Basic Instant Notification',
          channelDescription:
              'Notification channel that can trigger notification instantly.',
          defaultColor: const Color(0xFFE05832),
          ledColor: Colors.white,
        ),
      ],
    );
  }

  static Future<void> notify(AppNotification notification) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    awesomeNotifications.createNotification(
      content: NotificationContent(
        id: notification.id.hashCode,
        title: getNotificationTitle(notification.data.action),
        payload: {
          'id': notification.id,
          'action': notification.data.action,
          'actionId': notification.data.actionId
        },
        body: notification.data.message,
        channelKey: 'instant_notification',
        largeIcon: notification.data.pictureUrl,
      ),
    );
  }

  static void onMessageOpenedAppListener(
    RemoteMessage remoteMessage,
    BuildContext buildContext,
    bool mounted,
  ) {
    final notification = AppNotification(
      id: remoteMessage.data["notificationId"] ?? "none-none",
      createdAt: Timestamp.now(),
      data: NotificationData.fromJson(remoteMessage.data),
      viewed: false,
      to: "this-user",
    );
    onNotificationClicked(notification, buildContext, mounted);
  }

  static listenActionStream(BuildContext context, bool mounted) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (receivedAction) async {
        if (receivedAction.payload != null &&
            receivedAction.payload?['action'] != null) {
          final actionId = receivedAction.payload?['actionId'];
          if (actionId == null) return;
          onNotificationClicked(
            AppNotification(
              id: receivedAction.payload?['id'] ?? "none-none",
              createdAt: Timestamp.now(),
              data: NotificationData(
                pictureUrl: receivedAction.payload?['pictureUrl'],
                action: receivedAction.payload?['action'] ?? "NOTIFY_USER",
                actionId: actionId,
                message: "Received a new notification",
              ),
              viewed: true,
              to: "this-user",
            ),
            context,
            mounted,
          );
        }
      },
      onNotificationCreatedMethod: (createdAction) async {},
      onNotificationDisplayedMethod: (receivedAction) async {},
      onDismissActionReceivedMethod: (receivedAction) async {},
    );
  }

  // Notification clicked
  static Future<void> onNotificationClicked(
    AppNotification notification,
    BuildContext context,
    bool mounted,
  ) async {
    AppService().markNotificationAsSeen(notification.id);

    switch (notification.data.action) {
      case 'ASSIGN_USER_SCHOOL':
        final school =
            await ClassServices().getSchool(notification.data.actionId);
        if (school == null || !mounted) return;
        pushPage(
          context,
          to: SchoolScreen(school: school),
        );
        break;
      case 'ASSIGN_USER_CLASS':
        final trClass =
            await ClassServices().getClass(notification.data.actionId);
        if (trClass == null || !mounted) return;
        pushPage(
          context,
          to: TeacherClassesScreen(teacherClass: trClass),
        );
        break;
      default:
    }
  }

  //Get notification title
  static String getNotificationTitle(String action) {
    switch (action) {
      case "ASSIGN_USER_CLASS":
        return "Assigned to a new class";
      case "UNASSIGN_USER_CLASS":
        return "Unassigned from a class";
      case "ASSIGN_USER_SCHOOL":
        return "Assigned to a new school";
      case "UNASSIGN_USER_SCHOOL":
        return "Unassigned from a school";
      default:
        return "E-connect - Teaching Application";
    }
  }

  //On log out
  static void onLogout() async {
    await AwesomeNotifications().dismissAllNotifications();
    await AwesomeNotifications().cancelAll();
  }
}
