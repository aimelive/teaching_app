import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/controllers/chats.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:e_connect_mobile/utils/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsProvider extends StatefulWidget {
  final Widget child;
  const ChatsProvider({super.key, required this.child});

  @override
  State<ChatsProvider> createState() => _ChatsProviderState();
}

class _ChatsProviderState extends State<ChatsProvider> {
  final _chatUtils = ChatUtils();
  final _chatsState = Get.put(ChatsState());
  final currentUser = Get.find<AuthState>().user.value!.id;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Collection.chat
            .where('receivers', arrayContains: currentUser)
            .snapshots(),
        builder: (_, snapshot) {
          bool hasError = snapshot.hasError;
          bool loading = snapshot.connectionState == ConnectionState.waiting;
          bool done = snapshot.connectionState == ConnectionState.active;

          if (hasError) {
            _chatsState.error.value = snapshot.error.toString();
          }
          if (loading) {
            _chatsState.isLoading.value = true;
          } else if (done) {
            _chatsState.isLoading.value = false;
          }
          bool finished = done && !loading && !hasError;

          if (finished && snapshot.data != null && mounted) {
            _chatsState.error.value = '';
            _chatUtils.mapChatsToState(
              snapshot.data!.docs,
              _chatsState,
              context,
              currentUser,
            );

            _chatsState.chatsByUser.value =
                _chatsState.groupChatsByUser(currentUser);
          }

          return widget.child;
        });
  }
}
