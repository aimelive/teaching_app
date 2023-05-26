import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/ui/screens/classes/teacher_classes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/colors.dart';
import '../../../helpers/ui_utils.dart';

class TodayCourseTile extends StatelessWidget {
  final TeacherClass teacherClass;
  const TodayCourseTile({
    super.key,
    required this.teacherClass,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => pushPage(
        context,
        to: TeacherClassesScreen(teacherClass: teacherClass),
      ),
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1a212121),
                    offset: Offset(0, 10),
                    blurRadius: 16,
                    spreadRadius: 0,
                  )
                ],
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SvgPicture.asset(
                getImagePath("user_pro_class_icon.svg"),
              ),
            ),
            addHorizontalSpace(10),
            Expanded(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacherClass.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(teacherClass.schoolName),
                ],
              ),
            ),
            addHorizontalSpace(10),
            Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                "04:00 - 04:40",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: secondaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
