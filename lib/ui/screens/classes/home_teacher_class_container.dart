import 'package:e_connect_mobile/ui/screens/home/widgets/today_course_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/controllers/teacher_class.dart';
import '../../constants/colors.dart';
import '../../helpers/ui_utils.dart';

class TeacherClassesHomeContainer extends StatefulWidget {
  const TeacherClassesHomeContainer({super.key});

  @override
  State<TeacherClassesHomeContainer> createState() =>
      _TeacherClassesHomeContainerState();
}

class _TeacherClassesHomeContainerState
    extends State<TeacherClassesHomeContainer> {
  final classesState = Get.find<TeacherClassesState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addVerticalSpace(4),
          Text("You have ${classesState.classes.length} class today!"),
          addVerticalSpace(20),
          Container(
            padding: EdgeInsets.only(
              right: 4.r,
              left: 20.w,
              top: 4.r,
              bottom: 4.r,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              color: secondaryColor.withOpacity(0.1),
            ),
            child: TextField(
              cursorColor: secondaryColor,
              decoration: InputDecoration(
                isDense: true,
                constraints: BoxConstraints(maxHeight: 40.h),
                suffixIcon: CircleAvatar(
                  backgroundColor: primaryColor,
                  foregroundColor: whiteColor,
                  child: Icon(
                    Icons.search,
                    size: 25.sp,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                ),
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
          addVerticalSpace(20),
          Text(
            "Today",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          addVerticalSpace(5),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Afternoon",
              style: TextStyle(
                color: secondaryColor,
              ),
            ),
          ),
          addVerticalSpace(5),
          Column(
            children: classesState.classes
                .map(
                  (teacherClass) => TodayCourseTile(teacherClass: teacherClass),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
