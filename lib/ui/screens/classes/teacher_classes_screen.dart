import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/data/providers/stream_provider.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/classes/widgets/class_assistant.dart';
import 'package:e_connect_mobile/ui/screens/classes/widgets/school_info_tile.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:e_connect_mobile/ui/widgets/custom_blur_widget.dart';
import 'package:e_connect_mobile/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherClassesScreen extends StatefulWidget {
  const TeacherClassesScreen({super.key, required this.teacherClass});
  final TeacherClass teacherClass;

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBlurWidget(
              imgUrl:
                  "https://cdn.pixabay.com/photo/2017/01/21/09/47/learn-1996846_1280.jpg",
              blur: 10,
              child: Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.5),
                ),
                child: Column(
                  children: [
                    CustomBackAppbar(title: widget.teacherClass.name),
                    const Spacer(),
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.alarm_on),
                            addVerticalSpace(5),
                            Text(
                              UiUtils.dateStatus(widget.teacherClass.date),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    addVerticalSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: whiteColor,
                                ),
                                addHorizontalSpace(5),
                                Text(
                                  "Date",
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                )
                              ],
                            ),
                            addVerticalSpace(8),
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                UiUtils.date(widget.teacherClass.date),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.alarm_on,
                                  color: whiteColor,
                                ),
                                addHorizontalSpace(5),
                                Text(
                                  "Time",
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                )
                              ],
                            ),
                            addVerticalSpace(8),
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                UiUtils.time(
                                  widget.teacherClass.date,
                                  widget.teacherClass.duration,
                                ),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    addVerticalSpace(10),
                  ],
                ),
              ),
            ),
            addVerticalSpace(10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "School Info",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  addVerticalSpace(15),
                  StreamProvider<School>(
                    collectionId: Collection.schoolCollectionId,
                    docId: widget.teacherClass.schoolId,
                    fromJson: (json) => School.fromJson(json),
                    onError: (error) => Text(error),
                    loading: const Text("Loading..."),
                    onSuccess: (school) => SchoolInfoTile(
                      school: school,
                      room: widget.teacherClass.room,
                    ),
                  ),
                  addVerticalSpace(10),
                  Text(
                    "Lessons Files",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  addVerticalSpace(20),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.teacherClass.files.length,
                      itemBuilder: (context, index) {
                        final file = widget.teacherClass.files[index];
                        return Container(
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 20.w),
                          child: InkWell(
                            onTap: () => UiUtils.gotoUrl(file.link),
                            borderRadius: BorderRadius.circular(8.r),
                            child: Ink(
                              width: 140,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 15,
                                    offset: const Offset(4, 4),
                                    color: secondaryColor.withOpacity(0.2),
                                  ),
                                  BoxShadow(
                                    blurRadius: 50,
                                    offset: const Offset(-2, -2),
                                    color: secondaryColor.withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    getImagePath(
                                      file.link.contains('/presentation/')
                                          ? 'ppt.png'
                                          : file.link.contains('/document/')
                                              ? 'doc.png'
                                              : 'drive.png',
                                    ),
                                    height: 50,
                                    width: 50,
                                  ),
                                  Text(
                                    file.title,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (widget.teacherClass.trAssistantId != null)
                    ClassAssistantWidget(
                      classId: widget.teacherClass.id,
                      trAssistantId: widget.teacherClass.trAssistantId!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
