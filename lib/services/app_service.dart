import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';

class AppService {
  final _chatsCollection = Collection.chat;
  final _feedback = Collection.feedback;
  final _notification = Collection.notification;

  dynamic sendMessage(ChatMessage message) async {
    try {
      await _chatsCollection.add(message.toJson());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> markMessageAsRead(String id, String currentUser) async {
    try {
      await _chatsCollection.doc(id).update({
        'views': FieldValue.arrayUnion([currentUser])
      });
      return;
    } catch (e) {
      return;
    }
  }

  dynamic addFeedback(Map<String, dynamic> feedback) async {
    try {
      await _feedback.add(feedback);
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> deleteNotification(String id) async {
    try {
      await _notification.doc(id).delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> markNotificationAsSeen(String id) async {
    try {
      await _notification.doc(id).update({'viewed': true});
    } catch (e) {
      return;
    }
  }
}
