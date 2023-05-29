import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/home/widgets/today_course_tile.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchoolClassses extends StatefulWidget {
  const SchoolClassses({
    super.key,
    required this.classes,
    required this.schoolName,
  });
  final String schoolName;
  final List<TeacherClass> classes;

  @override
  State<SchoolClassses> createState() => _SchoolClasssesState();
}

class _SchoolClasssesState extends State<SchoolClassses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomBackAppbar(
              title: widget.schoolName,
              color: Colors.black,
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${widget.classes.where((element) => UiUtils.isThisWeek(element.date.toDate())).length} this week.",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.classes.where((element) => UiUtils.isThisMonth(element.date.toDate())).length} this month.",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Text(
                  "My Classes at ${widget.schoolName}",
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    children: widget.classes
                        .map(
                          (trClass) => TeacherClassTile(teacherClass: trClass,isToday:false),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
