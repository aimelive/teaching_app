import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_connect_mobile/data/controllers/auth.dart';
import 'package:e_connect_mobile/data/models/school.dart';
import 'package:e_connect_mobile/ui/constants/colors.dart';
import 'package:e_connect_mobile/ui/helpers/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import 'school_card.dart';
import 'today_course_tile.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final authState = Get.find<AuthState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor.withOpacity(0.01),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(15),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    foregroundImage: CachedNetworkImageProvider(
                      authState.user.value!.profilePic,
                    ),
                  ),
                  badges.Badge(
                    badgeContent: Text(
                      "8",
                      style: TextStyle(color: whiteColor, fontSize: 10.sp),
                    ),
                    showBadge: true,
                    position: badges.BadgePosition.topEnd(),
                    child: SvgPicture.asset(
                      getIconPath("notification"),
                      height: 28.sp,
                      color: secondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(20),
            Text(
              "Hello, Aime!",
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            addVerticalSpace(4),
            const Text("You have 3 lectures today!"),
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
                          Text("MON",
                              style: TextStyle(
                                color: active ? whiteColor : secondaryDark,
                              )),
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
              children: [
                Course(
                  action: "Examination",
                  title: "Mathematics",
                  time: "9 AM - 11 AM",
                ),
                Course(
                  action: "Tests",
                  title: "English",
                  time: "12 PM - 13 PM",
                ),
              ]
                  .map(
                    (course) => TodayCourseTile(
                      course: course,
                    ),
                  )
                  .toList(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Schools",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.arrow_right_alt,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                    label: const Text(
                      "View More",
                    ),
                  ),
                ),
              ],
            ),
            // addVerticalSpace(12),
            SizedBox(
              height: 160.h,
              child: ListView.builder(
                  itemCount: School.schools.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final active = index == 0;
                    return SchoolCard(
                      active: active,
                      school: School.schools[index],
                    );
                  }),
            ),
            addVerticalSpace(12),
          ],
        ),
      ),
    );
  }
}
