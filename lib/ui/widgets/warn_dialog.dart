import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WarnDialogWidget extends StatelessWidget {
  const WarnDialogWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.okButtonText,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String okButtonText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: secondaryColor,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            addVerticalSpace(10),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade100,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    popPage(context);
                  },
                  style: ElevatedButton.styleFrom(
                      // foregroundColor: Colors.grey,
                      ),
                  child: const Text("Cancel"),
                ),
                addHorizontalSpace(10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                      // foregroundColor: secondaryColor,
                      ),
                  child: Text(okButtonText),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
