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
          Text("You have ${classesState.classes.length} lectures today!"),
          addVerticalSpace(20),
          Container(
            padding: EdgeInsets.only(
              right: 5.r,
              left: 20.r,
              bottom: 4.r,
              top: 4.r,
            ),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: TextFormField(
              style: TextStyle(
                color: secondaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
              cursorColor: secondaryColor,
              decoration: const InputDecoration(
                suffixIcon: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(Icons.search),
                ),
                hintStyle: TextStyle(color: secondaryDark),
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
          addVerticalSpace(20),
          Text(
            "Mon 24, Saturday",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          addVerticalSpace(12),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  final active = index == 0;
                  return Container(
                    width: 60.w,
                    margin: EdgeInsets.only(left: active ? 0 : 10.w),
                    decoration: BoxDecoration(
                      color: active
                          ? primaryColor
                          : secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "MON",
                          style: TextStyle(
                            color: active ? whiteColor : secondaryDark,
                          ),
                        ),
                        Text(
                          "24",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: active ? whiteColor : secondaryDark,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          addVerticalSpace(15),
          Text(
            "Today",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          addVerticalSpace(12),
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
