import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/models/teacher_class.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:e_connect_mobile/ui/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

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
            CustomBackAppbar(title: widget.teacherClass.name),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Teacher",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  addVerticalSpace(5),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25.r,
                      foregroundImage: const CachedNetworkImageProvider(
                        "https://cdn.pixabay.com/photo/2021/05/06/16/13/children-6233868_640.png",
                      ),
                    ),
                    title: const Text("Aime Ndayambaje"),
                    subtitle: const Text("Teacher"),
                  ),
                  addVerticalSpace(15),
                  Text(
                    "Teacher Assistant",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  addVerticalSpace(5),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25.r,
                      foregroundImage: const CachedNetworkImageProvider(
                        "https://cdn.pixabay.com/photo/2023/05/20/12/43/clubtail-dragonfly-8006480_640.jpg",
                      ),
                    ),
                    title: const Text("Aime Ndayambaje"),
                    subtitle: const Text("Teacher Assistant"),
                  ),
                  addVerticalSpace(15),
                  Text(
                    "Date Time",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  addVerticalSpace(5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      "24 May 2023 - 09:00 AM - 09:30 AM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  addVerticalSpace(15),
                  Text(
                    "Duration",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  addVerticalSpace(5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      "30 Minutes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  addVerticalSpace(15),
                  Text(
                    "Lessons Images",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  addVerticalSpace(10),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.teacherClass.images.length,
                        itemBuilder: (context, index) {
                          final image = widget.teacherClass.images[index];
                          return GestureDetector(
                            onTap: () => SwipeImageGallery(
                              context: context,
                              children: [
                                CachedNetworkImage(imageUrl: image),
                              ],
                            ).show(),
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: index == 0 ? 0 : 12.w),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6.r),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              width: 150,
                            ),
                          );
                        }),
                  ),
                  addVerticalSpace(15),
                  Text(
                    "Feedbacks",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
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
