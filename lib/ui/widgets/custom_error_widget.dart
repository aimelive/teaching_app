import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../helpers/ui_utils.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.error,
  });
  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline_outlined,
              size: 30.sp,
              color: secondaryColor,
            ),
            addVerticalSpace(10),
            Text(
             error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
