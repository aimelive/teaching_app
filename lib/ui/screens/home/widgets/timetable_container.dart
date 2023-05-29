import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_connect_mobile/data/controllers/teacher_class.dart';
import 'package:e_connect_mobile/services/pdf_service.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../timetable/timetable_class_tile.dart';

class TimeTableContainer extends StatefulWidget {
  const TimeTableContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeTableContainer> createState() => _TimeTableContainerState();
}

class _TimeTableContainerState extends State<TimeTableContainer> {
  DateTime currentDate = DateTime.now();
  late int _currentSelectedDayIndex = currentDate.weekday - 1;
  final _classesState = Get.find<TeacherClassesState>();
  final _pdf = PdfService();

  Widget _buildDayContainer(int index) {
    return InkWell(
      onTap: () {
        if (index == _currentSelectedDayIndex) return;
        if (index < _currentSelectedDayIndex) {
          setState(() {
            currentDate = currentDate.subtract(
              Duration(days: _currentSelectedDayIndex - index),
            );
            _currentSelectedDayIndex = index;
          });
          return;
        }
        setState(() {
          currentDate = currentDate.add(
            Duration(days: index - _currentSelectedDayIndex),
          );
          _currentSelectedDayIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: index == _currentSelectedDayIndex
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent),
        padding: const EdgeInsets.all(7.5),
        child: Text(
          weekDays[index],
          style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: index == _currentSelectedDayIndex
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildDays() {
    final List<Widget> children = [];

    for (var i = 0; i < weekDays.length; i++) {
      children.add(_buildDayContainer(i));
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * (0.85),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            right: false,
            left: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Time Table",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
          addVerticalSpace(10),
          Obx(() {
            final thisWeek = _classesState.classes
                .where((trClass) => UiUtils.isThisWeek(trClass.date.toDate()))
                .length;
            final thisMonth = _classesState.classes
                .where((trClass) => UiUtils.isThisMonth(trClass.date.toDate()))
                .length;
            return Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This week: ${thisWeek == 0 ? "no class" : thisWeek == 1 ? "1 class" : "$thisWeek classes"}",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor),
                  ),
                  addVerticalSpace(5),
                  Text(
                    "This month: ${thisMonth == 0 ? "no class" : thisMonth == 1 ? "1 class" : "$thisMonth classes"}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            );
          }),
          addVerticalSpace(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  ).then((value) {
                    if (value == null) return;
                    setState(() {
                      currentDate = value;
                      _currentSelectedDayIndex = value.weekday - 1;
                    });
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    addHorizontalSpace(10),
                    Text(
                      UiUtils.date(
                        Timestamp.fromDate(currentDate),
                      ),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                child: InkWell(
                  onTap: () async {
                    if (_classesState.classes.isEmpty) return;
                    final generatePdf = await _pdf.makePdf(
                      "26 May 2023",
                      "John Doe",
                      _classesState.classes,
                    );

                    if (generatePdf == null && mounted) {
                      UiUtils.showCustomSnackBar(
                        context: context,
                        errorMessage: "Unable to download PDF.",
                        backgroundColor: Colors.red.shade800,
                      );
                      return;
                    }
                    await _pdf.openFile(generatePdf!);
                    UiUtils.showMessage(
                      title: "Downloaded Schedule",
                      message:
                          "You have downloaded your schedule, check your phone to see!",
                      position: SnackPosition.BOTTOM,
                    );
                  },
                  borderRadius: BorderRadius.circular(7.r),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.download,
                        color: whiteColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          addVerticalSpace(15),
          _buildDays(),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          Obx(() {
            final currentDayClasses = _classesState.classes.where(
              (trClass) => UiUtils.equalDays(
                trClass.date.toDate(),
                currentDate,
              ),
            );
            if (currentDayClasses.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.campaign,
                      size: 50.sp,
                      color: primaryColor,
                    ),
                    addVerticalSpace(10),
                    Text(
                      "There are no class assigned on ${weekDaysFull[_currentSelectedDayIndex]}, ${UiUtils.date(Timestamp.fromDate(currentDate))}.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: currentDayClasses
                  .map(
                    (trClass) => TimeTableClassTile(
                      teacherClass: trClass,
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}
