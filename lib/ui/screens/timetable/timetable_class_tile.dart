import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/classes/teacher_classes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class TimeTableClassTile extends StatelessWidget {
  final TeacherClass teacherClass;
  const TimeTableClassTile({
    super.key,
    required this.teacherClass,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pushPage(
        context,
        to: TeacherClassesScreen(teacherClass: teacherClass),
      ),
      child: Container(
        clipBehavior: Clip.none,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.075),
              offset: const Offset(4, 4),
              blurRadius: 10,
              spreadRadius: 0,
            )
          ],
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Icon(
                Icons.school,
                color: whiteColor,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 15.sp,
                        color: primaryColor,
                      ),
                      addHorizontalSpace(5),
                      Expanded(
                        child: Text(
                          UiUtils.time(
                            teacherClass.date,
                            teacherClass.duration,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(2),
                  Row(
                    children: [
                      Icon(
                        Icons.local_library_outlined,
                        size: 15.sp,
                        color: primaryColor,
                      ),
                      addHorizontalSpace(5),
                      Expanded(
                        child: Text(
                          teacherClass.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(2),
                  Row(
                    children: [
                      Icon(
                        Icons.festival_outlined,
                        size: 15.sp,
                        color: primaryColor,
                      ),
                      addHorizontalSpace(5),
                      Expanded(
                        child: Text(
                          teacherClass.schoolName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
