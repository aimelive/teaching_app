import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/models/chat.dart';

class ChatsService {
  final _chatsCollection = FirebaseFirestore.instance.collection('chatMessages');

  dynamic sendMessage(ChatMessage message) async {
    try {
      await _chatsCollection.add(message.toJson());
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
