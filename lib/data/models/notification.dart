import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  String id;
  Timestamp createdAt;
  NotificationData data;
  bool viewed;
  String to;

  AppNotification({
    required this.id,
    required this.createdAt,
    required this.data,
    required this.viewed,
    required this.to,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json, String id) =>
      AppNotification(
        id: id,
        createdAt: json["createdAt"],
        data: NotificationData.fromJson(json["data"]),
        viewed: json["viewed"],
        to: json["to"],
      );

  // Map<String, dynamic> toJson() => {
  //       "createdAt": createdAt.toDate().toIso8601String(),
  //       "data": data.toJson(),
  //       "viewed": viewed,
  //       "to": to,
  //     };
}

class NotificationData {
  String action;
  String actionId;
  String message;
  String? pictureUrl;

  NotificationData({
    required this.pictureUrl,
    required this.action,
    required this.actionId,
    required this.message,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        action: json["action"] ?? "NOTIFY_USER",
        actionId: json["actionId"] ?? "",
        message: json["message"] ?? "Received new notification",
        pictureUrl: json["pictureUrl"] ??
            "https://cdn.pixabay.com/photo/2016/10/12/02/54/girl-1733345_1280.jpg",
      );

  // Map<String, dynamic> toJson() => {
  //       "action": action,
  //       "actionId": actionId,
  //       "message": message,
  //     };
}
