import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:get/get.dart';

class ChatsState extends GetxController {
  //Values
  RxList<ChatMessage> chats = RxList<ChatMessage>([]);
  RxList<UserChatMessage> chatsByUser = RxList<UserChatMessage>([]);
  RxInt unread = RxInt(0);

  //State
  RxBool isLoading = RxBool(false);
  RxString error = RxString('');

  //Mutations
  void groupChatsByUser(String? currentUser) {
    if (currentUser == null) return;
    for (ChatMessage chat in chats) {
      try {
        final user = UserChatMessage(
          unread: chats
              .where(
                (el) =>
                    el.groupInfo.id == chat.groupInfo.id &&
                    chat.views.contains(currentUser),
              )
              .length,
          latestMessage:
              chats.lastWhere((el) => el.groupInfo.id == chat.groupInfo.id),
        );

        final index = chatsByUser.indexWhere(
          (c) => c.latestMessage.groupInfo.id == chat.groupInfo.id,
        );
        if (index == -1) {
          chatsByUser.add(user);
        } else {
          chatsByUser[index] = user;
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
