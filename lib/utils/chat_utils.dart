import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/chats.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:e_connect_mobile/services/chat_service.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';

class ChatUtils {
  //Searvice instance
  final _chatsService = ChatsService();
  //Stream service
  final Stream<QuerySnapshot> chatsStream =
      FirebaseFirestore.instance.collection('chatMessages').snapshots();

  void mapChatsToState(List<QueryDocumentSnapshot<Object?>> docs,
      ChatsState state, BuildContext context) {
    try {
      final chats = docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return ChatMessage.fromJson(data);
      });

      final filtered = chats
          .where((chat) =>
              chat.receiverId == "mo5LZbbY05Zxnyr7P9Yy" ||
              chat.senderId == "mo5LZbbY05Zxnyr7P9Yy")
          .toList();
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      state.chats.value = filtered;
      state.unread.value = filtered
          .where(
            (chat) => !chat.seen && chat.receiverId == "mo5LZbbY05Zxnyr7P9Yy",
          )
          .length;
          
    } catch (e) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Something went wrong, $e, restart the app.",
        backgroundColor: secondaryColor,
      );
    }
  }

  void sendMessage(
    ChatMessage message,
    BuildContext context,
    bool mounted,
  ) async {
    final result = await _chatsService.sendMessage(message);
    if (result != true && result.runtimeType == String && mounted) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage: "Sending message failed: $result",
        backgroundColor: secondaryColor,
      );
    }
  }
}
