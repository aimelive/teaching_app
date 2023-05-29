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
  List<UserChatMessage> groupChatsByUser(String? currentUser) {
    List<UserChatMessage> groupedChats = [];
    if (currentUser == null) [];
    for (ChatMessage chat in chats) {
      try {
        final user = UserChatMessage(
          unread: chats
              .where(
                (el) =>
                    el.groupInfo.id == chat.groupInfo.id &&
                    !el.views.contains(currentUser),
              )
              .length,
          latestMessage:
              chats.lastWhere((el) => el.groupInfo.id == chat.groupInfo.id),
        );

        final index = groupedChats.indexWhere(
          (c) => c.latestMessage.groupInfo.id == chat.groupInfo.id,
        );
        if (index == -1) {
          groupedChats.add(user);
        } else {
          groupedChats[index] = user;
        }
      } catch (e) {
        // print(e);
      }
    }
    return groupedChats;
  }
}
