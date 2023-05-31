import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../helpers/ui_utils.dart';
import '../chat_room.dart';

class ChatUserTile extends StatelessWidget {
  final UserChatMessage user;
  final String currentUserId;

  const ChatUserTile({
    super.key,
    required this.user,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    bool iAmReceiver = user.latestMessage.senderId != currentUserId &&
        !user.latestMessage.isGroup;
    bool isMe = user.latestMessage.senderId == currentUserId;
    bool hasViewed = isMe &&
        user.latestMessage.views.length == user.latestMessage.receivers.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: InkWell(
        onTap: () => pushPage(
          context,
          to: ChatRoom(user: user),
        ),
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: secondaryColor.withOpacity(0.1),
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                foregroundImage: CachedNetworkImageProvider(
                  iAmReceiver
                      ? user.latestMessage.senderInfo.avatar
                      : user.latestMessage.groupInfo.avatar,
                ),
              ),
              addHorizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      iAmReceiver
                          ? user.latestMessage.senderInfo.name
                          : user.latestMessage.groupInfo.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    addVerticalSpace(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (user.latestMessage.isGroup)
                          Row(
                            children: [
                              if (user.latestMessage.senderId == currentUserId)
                                Text(
                                  "You: ",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  ),
                                )
                              else
                                Text(
                                  "${user.latestMessage.senderInfo.name.split(' ')[0].length < 6 ? user.latestMessage.senderInfo.name.split(' ')[0] : user.latestMessage.senderInfo.name.substring(0, 5)}: ",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  ),
                                ),
                            ],
                          ),
                        if (user.latestMessage.image != null)
                          Container(
                            margin: EdgeInsets.only(right: 5.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3.r),
                              child: CachedNetworkImage(
                                imageUrl: user.latestMessage.image!,
                                height: 15,
                                width: 20,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            (hasViewed
                                    ? "✓ "
                                    : isMe
                                        ? "⌑ "
                                        : "") +
                                user.latestMessage.message,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              addHorizontalSpace(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 14.sp,
                      ),
                      addHorizontalSpace(4),
                      Text(getTimeAgo(user.latestMessage.createdAt))
                    ],
                  ),
                  addVerticalSpace(5),
                  if (user.unread > 0)
                    CircleAvatar(
                      radius: user.unread < 10
                          ? 10.r
                          : user.unread < 100
                              ? 12.r
                              : 16.r,
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      child: Text(
                        "${user.unread > 99 ? "99+" : user.unread}",
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
