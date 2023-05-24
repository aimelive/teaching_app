import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatCustomAppbar extends StatelessWidget {
  final VoidCallback onClick;
  const ChatCustomAppbar({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      right: false,
      left: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Chats",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: onClick,
              icon: Icon(
                Icons.add_circle_outline,
                size: 26.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
