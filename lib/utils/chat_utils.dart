import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/chats.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:e_connect_mobile/services/app_service.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';

class ChatUtils {
  //Searvice instance
  final _chatsService = AppService();

  void mapChatsToState(List<QueryDocumentSnapshot<Object?>> docs,
      ChatsState state, BuildContext context, String? currentUser) {
    try {
      if (currentUser == null) return;
      final chats = docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return ChatMessage.fromJson(data, document.id);
      });
      final filtered = chats.toList();
      filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      state.chats.value = [...filtered];
      state.unread.value = filtered
          .where(
            (chat) => !chat.views.contains(currentUser),
          )
          .length;
    } catch (e) {
      // print(e);
      // UiUtils.showCustomSnackBar(
      //   context: context,
      //   errorMessage: "Something went wrong, $e, restart the app.",
      //   backgroundColor: secondaryColor,
      // );
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

  void markMessagesAsRead(List<String> messages, String currentUser) async {
    for (String messageId in messages) {
      await _chatsService.markMessageAsRead(messageId, currentUser);
    }
  }
}
