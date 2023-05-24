import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../helpers/ui_utils.dart';
import '../chat_room.dart';

class ChatUserTile extends StatelessWidget {
  final UserChatMessage user;

  const ChatUserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: InkWell(
        onTap: () => pushPage(context,
            to: ChatRoom(
              user: user,
            )),
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
                  user.latestMessage.groupInfo.avatar,
                ),
              ),
              addHorizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.latestMessage.groupInfo.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    addVerticalSpace(5),
                    Text(
                      user.latestMessage.message,
                      maxLines: 1,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
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
                      radius: 10.r,
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      child: Text(
                        user.unread.toString(),
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
