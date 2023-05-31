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

  factory AppNotification.fromJson(Map<String, dynamic> json,String id) =>
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

  NotificationData({
    required this.action,
    required this.actionId,
    required this.message,
  });

  NotificationData copyWith({
    String? action,
    String? actionId,
    String? message,
    String? pictureUrl,
  }) =>
      NotificationData(
        action: action ?? this.action,
        actionId: actionId ?? this.actionId,
        message: message ?? this.message,
      );

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        action: json["action"],
        actionId: json["actionId"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "actionId": actionId,
        "message": message,
      };
}
