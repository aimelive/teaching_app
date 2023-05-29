import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/data/providers/stream_list_provider.dart';
import 'package:e_connect_mobile/ui/screens/classes/teacher_classes_screen.dart';
import 'package:e_connect_mobile/ui/screens/home/widgets/today_course_tile.dart';
import 'package:e_connect_mobile/ui/widgets/custom_circular_progress.dart';
import 'package:e_connect_mobile/ui/widgets/custom_error_widget.dart';
import 'package:e_connect_mobile/ui/widgets/search_input.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
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
      () {
        final len = classesState.todayClasses.length;
        final morning = classesState.todayClasses
            .where((trClass) => !(trClass.date.toDate().hour >= 12))
            .toList();
        final afterNoon = classesState.todayClasses
            .where((trClass) => trClass.date.toDate().hour >= 12)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(4),
            Text(
              "You have ${len == 0 ? "no class" : len == 1 ? "1 class" : "$len classes"} today!",
            ),
            addVerticalSpace(20),
            SearchInput<TeacherClass>(
              isHomeSearchbarForClasses: true,
              onClosed: (trClass) {
                if (trClass == null) return;
                pushPage(
                  context,
                  to: TeacherClassesScreen(teacherClass: trClass),
                );
              },
              delegate: MyCustomSearchDelegate(
                hintText: "Search classes",
                onSearchingSuggestionsBuilder: (query, showResults) {
                  return StreamListProvider<TeacherClass>(
                    query: Collection.classes.where(
                      'name',
                      isGreaterThanOrEqualTo: query,
                      isLessThan: '${query}z',
                    ),
                    fromJson: (json, id) => TeacherClass.fromJson(json),
                    loading: const CustomCircularProgressIndicator(),
                    onError: (error) {
                      return CustomErrorWidget(
                        error: "Something went wrong $error",
                      );
                    },
                    onSuccess: (messages) {
                      if (messages.isEmpty) {
                        return const CustomErrorWidget(
                            error: "No class found!");
                      }

                      return ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final suggestion = messages[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Icon(
                                  Icons.school,
                                  size: 20.sp,
                                ),
                              ),
                              title: Text(suggestion.name),
                              subtitle: Text(suggestion.schoolName),
                              onTap: () {
                                query = suggestion.name;
                                showResults(context);
                                popPage<TeacherClass>(
                                  context,
                                  data: suggestion,
                                );
                              },
                            );
                          });
                    },
                  );
                },
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
            if (len == 0)
              const CustomErrorWidget(
                error:
                    "There are no classes assigned to you, today!\nCheck your time table to see other schedules.",
              ),
            if (morning.isNotEmpty)
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Morning",
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  addVerticalSpace(5),
                  Column(
                    children: morning
                        .map(
                          (teacherClass) =>
                              TeacherClassTile(teacherClass: teacherClass),
                        )
                        .toList(),
                  ),
                ],
              )
            else if (len > 0)
              Container(
                margin: EdgeInsets.all(12.r),
                child: const Text("You have no morning classes today."),
              ),
            addVerticalSpace(5),
            if (afterNoon.isNotEmpty)
              Column(
                children: [
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
                    children: afterNoon
                        .map(
                          (teacherClass) =>
                              TeacherClassTile(teacherClass: teacherClass),
                        )
                        .toList(),
                  ),
                ],
              )
            else if (len > 0)
              Container(
                margin: EdgeInsets.all(12.r),
                child: const Text("You have no afternoon classes today."),
              ),
          ],
        );
      },
    );
  }
}
