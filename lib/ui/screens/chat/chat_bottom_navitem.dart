import 'package:e_connect_mobile/data/controllers/chats.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

import '../../constants/colors.dart';

class ChatBottomNavItem extends StatefulWidget {
  const ChatBottomNavItem({super.key, required this.isActive});
  final bool isActive;

  @override
  State<ChatBottomNavItem> createState() => _ChatBottomNavItemState();
}

class _ChatBottomNavItemState extends State<ChatBottomNavItem> {
  final _chatsState = Get.put(ChatsState());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return badges.Badge(
        badgeContent: Text(
          _chatsState.unread.value.toString(),
          style: TextStyle(color: whiteColor, fontSize: 10.sp),
        ),
        showBadge: _chatsState.chats.isNotEmpty && _chatsState.unread.value != 0
            ? true
            : false,
        position: badges.BadgePosition.topEnd(),
        child: SvgPicture.asset(
          getIconPath("chat"),
          // ignore: deprecated_member_use
          color: widget.isActive ? primaryColor : secondaryDark,
        ),
      );
    });
  }
}
