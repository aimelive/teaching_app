import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/chats.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/chat/input_container.dart';
import 'package:e_connect_mobile/utils/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scroll_when_needed/scroll_when_needed.dart';

import 'widgets/chat_room_appbar.dart';

class ChatRoom extends StatefulWidget {
  final UserChatMessage user;
  const ChatRoom({super.key, required this.user});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _chatUtils = ChatUtils();
  final _chatsState = Get.find<ChatsState>();

  final _scrollController = ScrollController();

  List<ChatMessage> thisUser(RxList<ChatMessage> chats) {
    return chats
        .where(
          (chat) => chat.senderId == widget.user.latestMessage.senderId,
        )
        .toList();
  }

  void _scrollDown() {
    if (thisUser(_chatsState.chats).isEmpty || !_scrollController.hasClients) {
      return;
    }

    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatRoomAppbar(user: widget.user),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollWhenNeededBehavior(),
              child: Obx(() {
                return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: EdgeInsets.zero,
                    physics: ScrollWhenNeededPhysics(
                      targetPlatform: Theme.of(context).platform,
                    ),
                    itemCount: thisUser(_chatsState.chats).length,
                    itemBuilder: (_, index) {
                      final message =
                          thisUser(_chatsState.chats).reversed.toList()[index];
                      return ChatMessageTile(
                        message: message,
                        isMe: message.receiverId == "mo5LZbbY05Zxnyr7P9Yy",
                      );
                    });
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: InputContainer(
        onSend: (message) {
          _chatUtils.sendMessage(
            ChatMessage(
              senderId: "mo5LZbbY05Zxnyr7P9Yy",
              avatar:
                  "https://cdn.pixabay.com/photo/2023/01/30/09/14/rain-7755142_640.png",
              receiverId: "mo5LZbbY05Zxnyr7P9Yy",
              message: message,
              seen: false,
              createdAt: Timestamp.now(),
              name: "Aime Ndayambaje",
            ),
            context,
            mounted,
          );
          _scrollDown();
        },
      ),
    );
  }
}

class ChatMessageTile extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const ChatMessageTile({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? secondaryColor : primaryColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(isMe ? 0 : 15.r),
              bottomLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
              topLeft: Radius.circular(isMe ? 15.r : 0),
            ),
          ),
          margin: EdgeInsets.symmetric(
            vertical: 5.h,
            horizontal: 15.w,
          ),
          padding: EdgeInsets.fromLTRB(15.w, 10.r, 10.r, 10.r),
          constraints: BoxConstraints(maxWidth: 200.w),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: message.message,
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 15.sp,
                  ),
                ),
                TextSpan(
                  text: "   ~${getTimeAgo(message.createdAt)}",
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
