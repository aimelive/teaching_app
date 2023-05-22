import 'package:e_connect_mobile/data/controllers/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/search_input.dart';
import '../../chat/widgets/chat_custom_appbar.dart';
import '../../chat/widgets/chat_user_tile.dart';

class ChatContainer extends StatefulWidget {
  const ChatContainer({super.key});

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  final _chatState = Get.find<ChatsState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ChatCustomAppbar(),
          const SearchInput(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Obx(() => Column(
                  children: _chatState.chatsByUser
                      .map(
                        (message) => ChatUserTile(user: message),
                      )
                      .toList(),
                )),
          )
        ],
      ),
    );
  }
}
