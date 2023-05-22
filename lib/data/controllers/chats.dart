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
  void groupChatsByUser() {
    for (ChatMessage chat in chats) {
      try {
        final user = UserChatMessage(
          unread: chats
              .where(
                (element) => element.senderId == chat.senderId && !element.seen,
              )
              .length,
          latestMessage: chats.lastWhere(
            (element) => element.senderId == chat.senderId,
          ),
        );

        final index = chatsByUser.indexWhere(
          (c) => c.latestMessage.senderId == chat.senderId,
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
