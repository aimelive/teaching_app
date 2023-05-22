import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InputContainer extends StatefulWidget {
  const InputContainer({super.key, required this.onSend});
  final void Function(String message) onSend;

  @override
  State<InputContainer> createState() => _InputContainerState();
}

class _InputContainerState extends State<InputContainer> {
  final _radius = BorderRadius.circular(25.r);
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // color: lightPrimary.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              backgroundColor: secondaryColor.withOpacity(0.1),
              radius: 22.r,
              child: Icon(
                Icons.add,
                size: 22.sp,
                color: primaryColor,
              ),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _radius,
                  color: secondaryColor.withOpacity(0.1),
                ),
                child: TextField(
                  controller: _textEditingController,
                  cursorColor: secondaryColor,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 8,
                  decoration: InputDecoration(
                    isDense: true,
                    hintStyle: const TextStyle(color: primaryColor),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    hintText: "Send a message",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            addHorizontalSpace(10),
            InkWell(
              borderRadius: _radius,
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_textEditingController.text.trim().isEmpty) return;
                widget.onSend(_textEditingController.text.trim());
                _textEditingController.clear();
              },
              child: Ink(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: _radius,
                ),
                child: Transform.rotate(
                  angle: 100,
                  child: SvgPicture.asset(
                    getIconPath("send"),
                    color: primaryColor,
                  ),
                ),
                // child: Row(
                //   children: [
                //     const Text(
                //       " Send",
                //       style: TextStyle(
                //         color: primaryColor,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //     addHorizontalSpace(7),
                //     Icon(
                //       Icons.send,
                //       size: 20.sp,
                //       color: primaryColor,
                //     ),
                //   ],
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
