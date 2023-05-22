import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String senderId;
  String avatar;
  String receiverId;
  String message;
  Timestamp createdAt;
  bool seen;
  String name;

  ChatMessage({
    required this.senderId,
    required this.avatar,
    required this.receiverId,
    required this.message,
    required this.seen,
    required this.createdAt,
    required this.name,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        senderId: json["senderId"],
        avatar: json["avatar"],
        receiverId: json["receiverId"],
        message: json["message"],
        seen: json["seen"],
        createdAt: json["createdAt"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "avatar": avatar,
        "receiverId": receiverId,
        "message": message,
        "createdAt": createdAt,
        "seen": seen,
        "name": name,
      };
}

class UserChatMessage {
  ChatMessage latestMessage;
  int unread;

  UserChatMessage({
    required this.unread,
    required this.latestMessage,
  });
}
