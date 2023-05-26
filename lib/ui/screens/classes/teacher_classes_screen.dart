import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/data/providers/single_school_provider.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/classes/widgets/feedback_form.dart';
import 'package:e_connect_mobile/ui/screens/classes/widgets/school_info_tile.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:e_connect_mobile/ui/widgets/custom_blur_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherClassesScreen extends StatefulWidget {
  const TeacherClassesScreen({super.key, required this.teacherClass});
  final TeacherClass teacherClass;

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
  bool _showFeebackForm = false;
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.alarm_on),
                          addVerticalSpace(5),
                          const Text(
                            "Today",
                            style: TextStyle(
                              color: whiteColor,
                            ),
                          ),
                        ],
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
                                "26 May 2023",
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
                                "04:00 PM - 04:40 PM",
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
                  SingleSchoolProvider(
                    onError: (error) => Text(error),
                    loading: const Text("Loading..."),
                    onSuccess: (school) => SchoolInfoTile(
                      school: school,
                      room: widget.teacherClass.room,
                    ),
                    schoolId: widget.teacherClass.schoolId,
                  ),
                  // LessonsImages(
                  //   images: widget.teacherClass.images,
                  //   classId: widget.teacherClass.id,
                  // ),
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
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://1000logos.net/wp-content/uploads/2020/08/Google-Drive-Logo-2012.png",
                                    height: 60,
                                    width: 60,
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
                  addVerticalSpace(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Class Assistant",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                      addVerticalSpace(5),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 25.r,
                          foregroundImage: const CachedNetworkImageProvider(
                            "https://cdn.pixabay.com/photo/2023/05/20/12/43/clubtail-dragonfly-8006480_640.jpg",
                          ),
                        ),
                        title: const Text("Aime Ndayambaje"),
                        subtitle: const Text("Teacher Assistant"),
                        trailing: GestureDetector(
                          onTap: () => setState(
                              () => _showFeebackForm = !_showFeebackForm),
                          child: Icon(
                            Icons.forum_outlined,
                            color: _showFeebackForm ? primaryColor : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showFeebackForm)
                    FeedBackForm(
                      onClose: () => setState(() => _showFeebackForm = false),
                    ),
                  addVerticalSpace(15),
                  // Text(
                  //   "Feedbacks",
                  //   style: TextStyle(
                  //     fontSize: 18.sp,
                  //     fontWeight: FontWeight.w800,
                  //     color: primaryColor,
                  //   ),
                  // ),
                  // addVerticalSpace(15),
                  // Column(
                  //   children: ["Teacher", "Assistant"]
                  //       .map((feeback) => Container(
                  //             padding: EdgeInsets.all(12.r),
                  //             margin: EdgeInsets.only(bottom: 10.h),
                  //             decoration: BoxDecoration(
                  //               color: secondaryColor.withOpacity(0.1),
                  //               borderRadius: BorderRadius.circular(12.r),
                  //             ),
                  //             child: Row(
                  //               children: [
                  //                 Expanded(
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           Text(
                  //                             feeback,
                  //                             style: TextStyle(
                  //                               fontSize: 18.sp,
                  //                               fontWeight: FontWeight.w500,
                  //                             ),
                  //                           ),
                  //                           addHorizontalSpace(5),
                  //                           const RateStarsWidget(value: 3)
                  //                         ],
                  //                       ),
                  //                       addVerticalSpace(5),
                  //                       const Text(
                  //                         "Lorem ipsum dolor isit,ipsum dolor isit,ipsum dolor isit isit,ipsum dolor isit, isit,ipsum dolor isit isit,ipsum dolor isit isit,ipsum dolor isit",
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ))
                  //       .toList(),
                  // ),
                  // addVerticalSpace(15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
