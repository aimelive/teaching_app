import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/ui_utils.dart';

class ChatRoomAppbar extends StatelessWidget {
  final UserChatMessage user;
  const ChatRoomAppbar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                popPage(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            addHorizontalSpace(10),
            CircleAvatar(
              radius: 22.r,
              foregroundImage:
                  CachedNetworkImageProvider(user.latestMessage.avatar),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.latestMessage.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("${user.unread} unread messages"),
                ],
              ),
            ),
            addHorizontalSpace(10),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Material(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: const Icon(
                      Icons.more_vert,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
